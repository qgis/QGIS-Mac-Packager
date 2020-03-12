#!/bin/bash

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building QGIS dependencies for MacOS platform"
else
  echo "Unable to build MacOS binaries on $OSTYPE"
  exit 1;
fi

# Internals
CRED="\x1b[31;01m"
CBLUE="\x1b[34;01m"
CGRAY="\x1b[30;01m"
CRESET="\x1b[39;49;00m"

function pop_env() {
  info "Leaving build environment"
  export PATH=$OLD_PATH
  export CFLAGS=$OLD_CFLAGS
  export CXXFLAGS=$OLD_CXXFLAGS
  export LDFLAGS=$OLD_LDFLAGS
  export CC=$OLD_CC
  export CXX=$OLD_CXX
  export MAKESMP=$OLD_MAKESMP
  export MAKE=$OLD_MAKE
  export LD=$OLD_LD
  export CMAKE=$OLD_CMAKE
  export CONFIGURE=$OLD_CONFIGURE
}

function try () {
    "$@" || exit -1
}

function info() {
  echo -e "$CBLUE"$@"$CRESET";
}

function error() {
  echo -e "$CRED"$@"$CRESET";
  pop_env
  exit -1
}

function debug() {
  echo -e "$CGRAY"$@"$CRESET";
}

#########################################################################################################
info "Loading configuration"
#########################################################################################################

SED="sed -i ''"
XCODE_DEVELOPER="$(xcode-select -print-path)"
CORES=$(sysctl -n hw.ncpu)
ARCH=x86_64
DO_CLEAN_BUILD=0
DO_SET_X=0
DEBUG=0

# Load configuration
source `dirname $0`/config.conf
if [ "X$RELEASE_TYPE" == "X" ]; then
  error "you need at RELEASE_TYPE in config.conf"
fi

if [ "X$MACOSX_DEPLOYMENT_TARGET" == "X" ]; then
  error "you need at MACOSX_DEPLOYMENT_TARGET in config.conf"
fi

if [ "X$QT_BASE" == "X" ]; then
  error "No QT_BASE environment set, abort"
fi

if [ -f $QT_BASE/clang_64/bin/qmake ]; then
   debug "Using QT: $QT_BASE"
else
   error "The file '$QT_BASE/clang_64/bin/qmake' in not found."
fi


if [ "X$PYTHON_BASE" == "X" ]; then
  error "No PYTHON_BASE environment set, abort"
fi

PYTHON=$PYTHON_BASE/bin/python3.7
if [ -f $PYTHON ]; then
   debug "Using Python: $PYTHON_BASE"
else
   error "The file '$PYTHON' in not found."
fi

if hash ${XCODE_DEVELOPER}/usr/bin/gcc 2>/dev/null; then
   debug "Compiler found at ${XCODE_DEVELOPER}/usr/bin"
else
   error "Unable to find compiler at ${XCODE_DEVELOPER}/usr/bin! Ensure that XCode is installed!"
fi

# Paths
ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_OUT_PATH="${ROOT_PATH}/../../builds/$RELEASE_TYPE-$ARCH/deps"
STAGE_PATH="${ROOT_OUT_PATH}/stage"
RECIPES_PATH="$ROOT_PATH/recipes"
BUILD_PATH="$ROOT_OUT_PATH/build"
PACKAGES_PATH="${PACKAGES_PATH:-$ROOT_OUT_PATH/.packages}"

function push_env() {
    info "Entering in build environment"

    export OLD_PATH=$PATH
    export OLD_CFLAGS=$CFLAGS
    export OLD_CXXFLAGS=$CXXFLAGS
    export OLD_LDFLAGS=$LDFLAGS
    export OLD_CC=$CC
    export OLD_CXX=$CXX
    export OLD_MAKESMP=$MAKESMP
    export OLD_MAKE=$MAKE
    export OLD_LD=$LD
    export OLD_CMAKE=$CMAKE
    export OLD_CONFIGURE=$CONFIGURE

    export CFLAGS="--sysroot $XCODE_DEVELOPER/SDKs/MacOSX.sdk -I$STAGE_PATH/include"
    export LDFLAGS="-L$STAGE_PATH/lib"
    export CXXFLAGS="${CFLAGS}"
    export PATH="/bin/:/usr/bin:${XCODE_DEVELOPER}/usr/bin:$STAGE_PATH/bin:/usr/local/bin"

    CMAKE="cmake"
    if [ $DEBUG -eq 1 ]; then
      # TODO debug mode for configure/make system
      CMAKE="${CMAKE} -DCMAKE_BUILD_TYPE=Debug"
    else
      CMAKE="${CMAKE} -DCMAKE_BUILD_TYPE=Release"
    fi
    export CMAKE="${CMAKE} -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH"
    # MACOSX_DEPLOYMENT_TARGET in environment should set minimum version
    export MAKESMP="${XCODE_DEVELOPER}/usr/bin/make -j$CORES"
    export MAKE="${XCODE_DEVELOPER}/usr/bin/make"
    export CONFIGURE="configure --prefix=$STAGE_PATH"

    export CC="${XCODE_DEVELOPER}/usr/bin/gcc $CFLAGS"
    export CXX="${XCODE_DEVELOPER}/usr/bin/g++ $CXXFLAGS"
    export LD="${XCODE_DEVELOPER}/usr/bin/ld"
}

#########################################################################################################
info "Check mandatory tools"
#########################################################################################################
push_env
MD5SUM=$(which md5sum)
if [ "X$MD5SUM" == "X" ]; then
  MD5SUM=$(which md5)
  if [ "X$MD5SUM" == "X" ]; then
    echo "Error: you need at least md5sum or md5 installed."
    exit 1
  else
    MD5SUM="$MD5SUM -r"
  fi
fi

WGET=$(which wget)
if [ "X$WGET" == "X" ]; then
  WGET=$(which curl)
  if [ "X$WGET" == "X" ]; then
    echo "Error: you need at least wget or curl installed."
    exit 1
  else
    WGET="$WGET -L -o"
  fi
  WHEAD="curl -L -I"
else
  WGET="$WGET -O"
  WHEAD="wget --spider -q -S"
fi

for tool in tar bzip2 unzip cmake; do
  which $tool &>/dev/null
  if [ $? -ne 0 ]; then
    error "Tool $tool is missing"
    exit -1
  fi
done
pop_env

#########################################################################################################
#########################################################################################################
#########################################################################################################

function get_directory() {
  case $1 in
    *.tar.gz) directory=$(basename $1 .tar.gz) ;;
    *.tgz)    directory=$(basename $1 .tgz) ;;
    *.tar.bz2)  directory=$(basename $1 .tar.bz2) ;;
    *.tbz2)   directory=$(basename $1 .tbz2) ;;
    *.zip)    directory=$(basename $1 .zip) ;;
    *.tar.xz) directory=$(basename $1 .tar.xz) ;;
    *)
      error "Unknown file extension $1"
      ;;
  esac
  echo $directory
}

function verify_lib_arch() {
  LIB_ARCHS=`lipo -archs $1`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library $1 was not successfully build for $ARCH, but ${LIB_ARCHS}"
  fi
}

function usage() {
  echo "QGIS deps - distribute.sh"
  echo
  echo "Usage:   ./distribute.sh [options]"
  echo
  echo "  -h                     Show this help"
  echo "  -l                     Show a list of available modules"
  echo "  -m 'mod1 mod2'         Modules to include"
  echo "  -f                     Restart from scratch (remove the current build)"
  echo "  -x                     display expanded values (execute 'set -x')"
  echo
  echo "For developers:"
  echo "  -u 'mod1 mod2'         Modules to update (if already compiled)"
  echo
  exit 0
}

function run_prepare() {
  if [ "X$MODULES" == "X" ]; then
    usage
    exit 0
  fi

  if [ $DO_CLEAN_BUILD -eq 1 ]; then
    info "Cleaning build"
    try rm -rf $STAGE_PATH
    try rm -rf $BUILD_PATH
  fi

  info "Distribution will be located at $STAGE_PATH"
  if [ -e "$STAGE_PATH" ]; then
    info "The directory $STAGE_PATH already exist"
    info "Will continue using and possibly overwrite what is in there"
  fi
  try mkdir -p "$STAGE_PATH"

  # create build directory if not found
  test -d $PACKAGES_PATH || mkdir -p $PACKAGES_PATH
  test -d $BUILD_PATH || mkdir -p $BUILD_PATH
  test -d $LIBS_PATH || mkdir -p $LIBS_PATH
}

function in_array() {
  term="$1"
  shift
  i=0
  for key in $@; do
    if [ $term == $key ]; then
      return $i
    fi
    i=$(($i + 1))
  done
  return 255
}

function run_source_modules() {
  # preprocess version modules
  needed=($MODULES)
  while [ ${#needed[*]} -ne 0 ]; do

    # pop module from the needed list
    module=${needed[0]}
    unset needed[0]
    needed=( ${needed[@]} )

    # is a version is specified ?
    items=( ${module//==/ } )
    module=${items[0]}
    version=${items[1]}
    if [ ! -z "$version" ]; then
      info "Specific version detected for $module: $version"
      eval "VERSION_$module=$version"
    fi
  done

  needed=($MODULES)
  declare -a processed
  declare -a pymodules
  processed=()

  fn_deps=$BUILD_PATH'/.deps'
  fn_optional_deps=$BUILD_PATH'/.optional-deps'

  > $fn_deps
  > $fn_optional_deps

  while [ ${#needed[*]} -ne 0 ]; do

    # pop module from the needed list
    module=${needed[0]}
    original_module=${needed[0]}
    unset needed[0]
    needed=( ${needed[@]} )

    # split the version if exist
    items=( ${module//==/ } )
    module=${items[0]}
    version=${items[1]}

    # check if the module have already been declared
    in_array $module "${processed[@]}"
    if [ $? -ne 255 ]; then
      debug "Ignored $module, already processed"
      continue;
    fi

    # add this module as done
    processed=( ${processed[@]} $module )

    # read recipe
    debug "Read $module recipe"
    recipe=$RECIPES_PATH/$module/recipe.sh
    if [ ! -f $recipe ]; then
      error "Recipe $module does not exist, adding the module as pure-python package"
      pymodules+=($original_module)
      continue;
    fi
    source $RECIPES_PATH/$module/recipe.sh

    # if a version has been specified by the user, the md5 will not
    # correspond at all. so deactivate it.
    if [ ! -z "$version" ]; then
      debug "Deactivate MD5 test for $module, due to specific version"
      eval "MD5_$module="
    fi

    # append current module deps to the needed
    deps=$(echo \$"{DEPS_$module[@]}")
    eval deps=($deps)
    optional_deps=$(echo \$"{DEPS_OPTIONAL_$module[@]}")
    eval optional_deps=($optional_deps)
    if [ ${#deps[*]} -gt 0 ]; then
      debug "Module $module depend on" ${deps[@]}
      needed=( ${needed[@]} ${deps[@]} )
      echo $module ${deps[@]} >> $fn_deps
    else
      echo $module >> $fn_deps
    fi
    if [ ${#optional_deps[*]} -gt 0 ]; then
      echo $module ${optional_deps[@]} >> $fn_optional_deps
    fi
  done

  info `pwd`
  MODULES="$($PYTHON tools/depsort.py --optional $fn_optional_deps < $fn_deps)"

  info "Modules changed to $MODULES"

  PYMODULES="${pymodules[@]}"

  info "Pure-Python modules changed to $PYMODULES"
}

function run_get_packages() {
  info "Run get packages"

  for module in $MODULES; do
    # download dependencies for this module
    # check if there is not an overload from environment
    module_dir=$(eval "echo \$OSGeo4QGIS_${module}_DIR")
    if [ "$module_dir" ]
    then
      debug "\$OSGeo4QGIS_${module}_DIR is not empty, linking $module_dir dir instead of downloading"
      directory=$(eval "echo \$BUILD_${module}")
      if [ -e $directory ]; then
        try rm -rf "$directory"
      fi
      try mkdir -p "$directory"
      try rmdir "$directory"
      try ln -s "$module_dir" "$directory"
      continue
    fi
    debug "Download package for $module"

    url="URL_$module"
    url=${!url}
    md5="MD5_$module"
    md5=${!md5}

    if [ ! -d "$BUILD_PATH/$module" ]; then
      try mkdir -p $BUILD_PATH/$module
    fi

    if [ ! -d "$PACKAGES_PATH/$module" ]; then
      try mkdir -p "$PACKAGES_PATH/$module"
    fi

    if [ "X$url" == "X" ]; then
      debug "No package for $module"
      continue
    fi

    filename=$(basename $url)
    marker_filename=".mark-$filename"
    do_download=1

    cd "$PACKAGES_PATH/$module"

    # check if the file is already present
    if [ -f $filename ]; then
      # if the marker has not been set, it might be cause of a invalid download.
      if [ ! -f $marker_filename ]; then
        rm $filename
      elif [ -n "$md5" ]; then
        # check if the md5 is correct
        current_md5=$($MD5SUM $filename | cut -d\  -f1)
        if [ "X$current_md5" == "X$md5" ]; then
          # correct, no need to download
          do_download=0
        else
          # invalid download, remove the file
          error "Module $module have invalid md5, redownload."
          rm $filename
        fi
      else
        do_download=0
      fi
    fi

    # check if the file HEAD in case of, only if there is no MD5 to check.
    check_headers=0
    if [ -z "$md5" ]; then
      if [ "X$DO_CLEAN_BUILD" == "X1" ]; then
        check_headers=1
      elif [ ! -f $filename ]; then
        check_headers=1
      fi
    fi

    # download if needed
    if [ $do_download -eq 1 ]; then
      info "Downloading $url"
      try rm -f $marker_filename
      try $WGET $filename $url
      touch $marker_filename
    else
      debug "Module $module already downloaded"
    fi

    # check md5
    if [ -n "$md5" ]; then
      current_md5=$($MD5SUM $filename | cut -d\  -f1)
      if [ "X$current_md5" != "X$md5" ]; then
        error "File $filename md5 check failed (got $current_md5 instead of $md5)."
        error "Ensure the file is correctly downloaded, and update MD5S_$module"
        exit -1
      fi
    fi

    # if already decompress, forget it
    cd $BUILD_PATH/$module
    directory=$(get_directory $filename)
    if [ -d "$directory" ]; then
      continue
    fi

    # decompress
    pfilename=$PACKAGES_PATH/$module/$filename
    info "Extract $pfilename"
    case $pfilename in
      *.tar.gz|*.tar.xz|*.tgz )
        try tar xzf $pfilename
        root_directory=$(basename $(try tar tzf $pfilename|head -n1))
        if [ "X$root_directory" != "X$directory" ]; then
          mv $root_directory $directory
        fi
        ;;
      *.tar.bz2|*.tbz2 )
        try tar xjf $pfilename
        root_directory=$(basename $(try tar tjf $pfilename|head -n1))
        if [ "X$root_directory" != "X$directory" ]; then
          mv $root_directory $directory
        fi
        ;;
      *.zip )
        try unzip $pfilename
        root_directory=$(basename $(try unzip -l $pfilename|sed -n 5p|awk '{print $4}'))
        if [ "X$root_directory" != "X$directory" ]; then
          mv $root_directory $directory
        fi
        ;;
    esac
  done
}

function run_prebuild() {
  info "Run prebuild"
  cd $BUILD_PATH
  for module in $MODULES; do
    fn=$(echo prebuild_$module)
    debug "Call $fn"
    $fn
  done
}

function run_build() {
  info "Run build"

  modules_update=($MODULES_UPDATE)

  cd $BUILD_PATH

  for module in $MODULES; do
    fn="build_$module"
    shouldbuildfn="shouldbuild_$module"
    MARKER_FN="$BUILD_PATH/.mark-$module"

    # if the module should be updated, then remove the marker.
    in_array $module "${modules_update[@]}"
    if [ $? -ne 255 ]; then
      debug "$module detected to be updated"
      rm -f "$MARKER_FN"
    fi

    # if shouldbuild_$module exist, call it to see if the module want to be
    # built again
    DO_BUILD=1
    if [ "$(type -t $shouldbuildfn)" == "function" ]; then
      $shouldbuildfn
    fi

    # if the module should be build, or if the marker is not present,
    # do the build
    if [ "X$DO_BUILD" == "X1" ] || [ ! -f "$MARKER_FN" ]; then
      debug "Call $fn"
      rm -f "$MARKER_FN"
      $fn
      touch "$MARKER_FN"
    else
      debug "Skipped $fn"
    fi
  done
}

function run_postbuild() {
  info "Run postbuild"
  cd $BUILD_PATH
  for module in $MODULES; do
    fn=$(echo postbuild_$module)
    debug "Call $fn"
    $fn
  done
}

function run() {
  cd ${ROOT_PATH}
  run_prepare
  run_source_modules
  run_get_packages
  run_prebuild
  run_build
  run_postbuild
  info "All done !"
}

function list_modules() {
  modules=$(find recipes -iname 'recipe.sh' | cut -d/ -f2 | sort -u | xargs echo)
  echo "Available modules: $modules"
  exit 0
}

# Do the build
while getopts ":hvlfxim:u:s:g" opt; do
  case $opt in
    h)
      usage
      ;;
    l)
      list_modules
      ;;
    s)
      run_prepare
      run_source_modules
      push_env
      bash
      pop_env
      exit 0
      ;;
    i)
      INSTALL=1
      ;;
    g)
      DEBUG=1
      echo "Requesting debug binaries"
      ;;
    m)
      MODULES="$OPTARG"
      ;;
    u)
      MODULES_UPDATE="$OPTARG"
      ;;
    f)
      DO_CLEAN_BUILD=1
      ;;
    x)
      DO_SET_X=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;

    *)
      echo "=> $OPTARG"
      ;;
  esac
done

if [ $DO_SET_X -eq 1 ]; then
  info "Set -x for displaying expanded values"
  set -x
fi

run
