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

  # deactivate python virtualenv
  if [ -f $STAGE_PATH/bin/activate ]; then
    deactivate nondestructive
  fi

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
  export INCLUDE=$OLD_INCLUDE
  export LIB_DIR=$OLD_LIB_DIR
  export LIB=$OLD_LIB
  export SYSROOT=$OLD_SYSROOT
  export PYTHON=$OLD_PYTHON
  export PYTHONUSERBASE=$OLD_PYTHONUSERBASE
  export DYLD_LIBRARY_PATH=$OLD_DYLD_LIBRARY_PATH
  export PIP=$OLD_PIP
}

function try () {
    "$@" || exit -1
}

function info() {
  echo -e "$CBLUE"$@"$CRESET";
}

function error() {
  MSG="$CRED"$@"$CRESET"
  pop_env
  echo -e $MSG;
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
if [ "X$RELEASE_VERSION" == "X" ]; then
  error "you need at RELEASE_VERSION in config.conf"
fi

if [ "X$MACOSX_DEPLOYMENT_TARGET" == "X" ]; then
  error "you need at MACOSX_DEPLOYMENT_TARGET in config.conf"
fi

if [ "X$VERSION_qt" == "X" ]; then
  error "No VERSION_qt environment set, abort"
fi

if [ "X$VERSION_python" == "X" ]; then
  error "No VERSION_python environment set, abort"
fi

if [ "X$QT_BASE" == "X" ]; then
  error "No QT_BASE environment set, abort"
fi

if [ -f $QT_BASE/clang_64/bin/qmake ]; then
   debug "Using QT: $QT_BASE"
else
   error "The file '$QT_BASE/clang_64/bin/qmake' in not found."
fi

if [ "X$SDKROOT" == "X" ]; then
  error "No SDKROOT environment set, abort"
fi
if [ -d $SDKROOT ]; then
   debug "Using SDK: $SDKROOT"
else
   error "The SDK directory '$SDKROOT' not found."
fi

if [ "X$PYTHON_BASE" == "X" ]; then
  error "No PYTHON_BASE environment set, abort"
fi

if [ -f $PYTHON_BASE/bin/python${VERSION_python} ]; then
   debug "Using Python: $PYTHON_BASE/bin/python${VERSION_python}"
else
   error "The file '$PYTHON_BASE/bin/python${VERSION_python}' in not found."
fi

# if hash ${XCODE_DEVELOPER}/usr/bin/clang 2>/dev/null; then
#   debug "Compiler found at ${XCODE_DEVELOPER}/usr/bin"
#else
#   error "Unable to find compiler at ${XCODE_DEVELOPER}/usr/bin! Ensure that XCode is installed!"
#fi

#if [ -d "${XCODE_DEVELOPER}/usr/lib/clang" ]; then
#   debug "Clang found at ${XCODE_DEVELOPER}/usr/bin"
#else
#   error "Unable to find clang at ${XCODE_DEVELOPER}/usr/lib/clang"
#fi

if [ "X$ROOT_OUT_PATH" == "X" ]; then
  error "No ROOT_OUT_PATH environment set, abort"
fi

if [ -d $ROOT_OUT_PATH ]; then
   debug "Using root output path: $ROOT_OUT_PATH"
else
   error "The root output directory '$ROOT_OUT_PATH' not found."
fi

# Paths
ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STAGE_PATH="${ROOT_OUT_PATH}/stage"
RECIPES_PATH="$ROOT_PATH/recipes"
BUILD_PATH="$ROOT_OUT_PATH/build"
PACKAGES_PATH="${PACKAGES_PATH:-$ROOT_OUT_PATH/.packages}"
QGIS_SITE_PACKAGES_PATH=${STAGE_PATH}/lib/python${VERSION_python}/site-packages

function add_homebrew_path() {
   # info "Adding /usr/local/opt/$1/bin to PATH"
   if [ ! -d "/usr/local/opt/$1/bin" ]; then
     error "Missing homebrew $1 /usr/local/opt/$1/bin"
   fi
   export PATH="/usr/local/opt/$1/bin:$PATH"
}

function check_file_configuration() {
  # "Checking $1 for /usr/local/lib"
  if grep -q /usr/local/lib $1
  then
    info "Found: "
    cat $1 | grep /usr/local/lib
    error "File $1 contains /usr/local/lib string <-- CMake picked some homebrew libs!"
  fi
}

function python_package_installed() {
    package_name=$1
    package_version=$2
    python_import=$3
    dist_name=${package_name}-${package_version}.dist-info
    if [ ! -d $QGIS_SITE_PACKAGES_PATH/$package_name ] && [ ! -d $QGIS_SITE_PACKAGES_PATH/$dist_name ] ; then
      return 1
    fi

    push_env
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib $PYTHON -c import\ $python_import > /dev/null 2>&1 || return 1
    pop_env

    return 0
}

function patch_configure_file() {
    try ${SED} 's;/usr/local/lib/ ;;g' $1
    try ${SED} 's; /usr/local/lib/;;g' $1
    try ${SED} 's;/usr/local/lib/;;g' $1
    try ${SED} 's; /usr/local/lib;;g' $1
    try $SED 's;/usr/local/lib ;;g' $1
    try $SED 's;/usr/local/lib;;g' $1
}

function patch_qmake_pri_file() {
  # Install in stage path
  try ${SED} "s;QWT_INSTALL_PREFIX.*=.*;QWT_INSTALL_PREFIX=$STAGE_PATH;g" $1

  # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`
  try ${SED} "s;= \$\${QWT_INSTALL_PREFIX}/plugins/designer;=$STAGE_PATH/lib/qt/plugins/designer;g" $1
}

# function run_qmake() {
  # ImageIO framework contains libTIFF and libJPEG libraries
  # we have these libraries in $STAGE_PATH/lib
  # so we should not set DYLD_LIBRARY_PATH=$STAGE_PATH/lib
  # otherwise qmake command will not go through

#  export OLD2_DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH
#  try ${QMAKE} "$@"
#  export DYLD_LIBRARY_PATH=$OLD2_DYLD_LIBRARY_PATH
#}

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
    export OLD_INCLUDE=$INCLUDE
    export OLD_LIB_DIR=$LIB_DIR
    export OLD_LIB=$LIB
    export OLD_SYSROOT=$SYSROOT
    export OLD_PYTHON=$PYTHON
    export OLD_PYTHONUSERBASE=$PYTHONUSERBASE
    export OLD_DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH
    export OLD_PIP=$PIP

    export PATH="/sbin/:/bin/:/usr/bin"
    add_homebrew_path bison
    add_homebrew_path flex
    add_homebrew_path cmake
    add_homebrew_path coreutils
    add_homebrew_path ccache
    add_homebrew_path autoconf
    add_homebrew_path automake
    add_homebrew_path libtool
    add_homebrew_path pkg-config

    ###################
    # Configure/Make system

    # export SYSROOT=$XCODE_DEVELOPER/SDKs/MacOSX.sdk
    # export CFLAGS="--sysroot $SYSROOT -I$STAGE_PATH/include"
    export CFLAGS="-I$STAGE_PATH/include"
    export LDFLAGS="-L$STAGE_PATH/lib"
    export CXXFLAGS="${CFLAGS}"

    export PATH="${PATH}:${XCODE_DEVELOPER}/usr/bin:$STAGE_PATH/bin:$QT_BASE/clang_64/bin"

    # export some tools
    export MAKESMP="/usr/bin/make -j$CORES"
    export MAKE="/usr/bin/make"
    export CONFIGURE="./configure --prefix=$STAGE_PATH --disable-dependency-tracking --disable-silent-rules"
    export CC="/usr/bin/clang"
    export CXX="/usr/bin/clang++"
    export OBJCXX=${CXX}
    export OBJC=${CC}

    # export CC="${XCODE_DEVELOPER}/usr/bin/gcc $CFLAGS"
    # export CXX="${XCODE_DEVELOPER}/usr/bin/g++ $CXXFLAGS"
    export LD="/usr/bin/ld"

    ###################
    # CMake

    export LIB=$STAGE_PATH
    export INCLUDE=$STAGE_PATH/include
    export LIB_DIR=$STAGE_PATH

    CMAKE="cmake"
    if [ $DEBUG -eq 1 ]; then
      CMAKE="${CMAKE} -DCMAKE_BUILD_TYPE=Debug"
    else
      CMAKE="${CMAKE} -DCMAKE_BUILD_TYPE=Release"
    fi
    export CMAKE="${CMAKE} -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH"
    # export CMAKE="${CMAKE} -DCMAKE_PREFIX_PATH=$STAGE_PATH;$QT_BASE/clang_64;$SYSROOT"
    export CMAKE="${CMAKE} -DCMAKE_PREFIX_PATH=$STAGE_PATH;$QT_BASE/clang_64"
    export CMAKE="${CMAKE} -DCMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH=FALSE"
    export CMAKE="${CMAKE} -DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=FALSE"
    export CMAKE="${CMAKE} -DCMAKE_INSTALL_RPATH=@executable_path/../lib"
    export CMAKE="${CMAKE} -DCMAKE_MACOSX_RPATH=ON"
    export CMAKE="${CMAKE} -DENABLE_TESTS=OFF"
    export CMAKE="${CMAKE} -DCMAKE_MACOSX_RPATH=ON"
    # MACOSX_DEPLOYMENT_TARGET in environment should set minimum version

    ###################
    # QMAKE
    # use run_qmake in the receipts
    export QMAKE="qmake -config release -spec macx-clang"

    ###################
    # PYTHON
    # activate python virtualenv

    # build_ext sometimes tries to dlopen the libraries
    # TODO THIS SHOULD NOT BE NECCESARRY IF ALL RPATHS are correct in binaries
    # to @executable_path/../lib/ and we should only fix the pip install global options
    # DYLD_LIBRARY_PATH=$STAGE_PATH/lib
    if [ -f $STAGE_PATH/bin/activate ]; then
      source $STAGE_PATH/bin/activate
    fi
    export PYTHON="$STAGE_PATH/bin/python3"
    export PIP="pip3 install --no-binary all"
    export PIP="$PIP --global-option=build_ext"
    export PIP="$PIP --global-option=--include-dirs=$STAGE_PATH/include"
    export PIP="$PIP --global-option=--library-dirs=$STAGE_PATH/lib"
}

#########################################################################################################
info "Check mandatory tools"
#########################################################################################################
push_env
MD5SUM=$(which md5sum)
if [ "X$MD5SUM" == "X" ]; then
  MD5SUM=$(which md5)
  if [ "X$MD5SUM" == "X" ]; then
    error "you need at least md5sum or md5 installed."
  else
    MD5SUM="$MD5SUM -r"
  fi
fi

WGET=$(which wget)
if [ "X$WGET" == "X" ]; then
  WGET=$(which curl)
  if [ "X$WGET" == "X" ]; then
    error "you need at least wget or curl installed."
  else
    WGET="$WGET -L -o"
  fi
  WHEAD="curl -L -I"
else
  WGET="$WGET -O"
  WHEAD="wget --spider -q -S"
fi

for tool in tar bzip2 unzip cmake bison flex autoconf automake libtool pkg-config autoreconf; do
  which $tool &>/dev/null
  if [ $? -ne 0 ]; then
    error "Tool $tool is missing"
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


function check_linked_rpath() {
  cd ${STAGE_PATH}
  if otool -L $1 | grep -q /usr/local/lib
  then
    otool -L $1
    error "$1 contains /usr/local/lib string <-- CMake picked some homebrew libs!"
  fi

  if otool -L $1 | grep -q $ROOT_OUT_PATH
  then
    otool -L $1
    error "$1 contains $ROOT_OUT_PATH string <-- forgot to change install_name for the linked library?"
  fi
}

function verify_lib() {
  cd ${STAGE_PATH}/
  LIB_ARCHS=`lipo -archs lib/$1`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library lib/$1 was not successfully build for $ARCH, but ${LIB_ARCHS}"
  fi

  check_linked_rpath lib/$1
}

function verify_bin() {
  cd ${STAGE_PATH}/
  LIB_ARCHS=`lipo -archs bin/$1`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Executable bin/$1 was not successfully build for $ARCH, but ${LIB_ARCHS}"
  fi

  check_linked_rpath bin/$1

  # check that the binary has the rpath to the lib folder
  if otool -l bin/$1 |grep -q "@executable_path/../lib"
  then
    : # OK!
  else
    otool -l bin/$1
    error "Executable bin/$1 does not contain rpath to lib folder $STAGE_PATH string <-- forgot to call install_name_tool -add_rpath @executable_path/../lib <exe> ? "
  fi

  # check that the binary has the rpath to the lib folder
  if otool -l bin/$1 |grep -q "$ROOT_OUT_PATH"
  then
    otool -l bin/$1
    error "Executable bin/$1 does contain rpath to lib folder $ROOT_OUT_PATH string <-- forgot to call install_name_tool -delete_rpath @executable_path/../lib <exe> ? "
  fi
}

run_final_check() {
  info "Running final check for all libraries in the ${STAGE_PATH}/lib"

  # libs
  cd ${STAGE_PATH}/lib
  LIBS1=`find . -type f -name "*.so"`
  LIBS2=`find . -type f -name "*.dylib"`
  LIBS="$LIBS1 $LIBS2"
  for lib in $LIBS; do
    verify_lib $lib
  done

  # frameworks
  cd ${STAGE_PATH}/lib
  LIBS=`find . -type f ! -name "*.*"`
  for lib in $LIBS; do
    attachmenttype=$(file ${STAGE_PATH}/bin/$lib | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      verify_lib $lib
    fi
  done

  info "Running final check for all binaries in the ${STAGE_PATH}/bin"
  # binaries
  cd ${STAGE_PATH}/bin
  EXEC=`find . -type f -name "*" ! -name "sip" ! -name "pip*" ! -name "activate*" ! -name "easy_install*" ! -name "python*"`
  for bin in $EXEC; do
    attachmenttype=$(file ${STAGE_PATH}/bin/$bin | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      verify_bin $bin
    fi
  done
}

function usage() {
  echo "QGIS deps - distribute.sh"
  echo
  echo "Usage:   ./distribute.sh [options]"
  echo
  echo "  -h                     Show this help"
  echo "  -c                     Run command in the build environment"
  echo "  -B                     open Qt Creator for QGIS development"
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
  else
    try mkdir -p "$STAGE_PATH"
  fi

  if [ ! -f $STAGE_PATH/bin/python3 ]; then
    info "Creating Python virtual environment"
    cd $STAGE_PATH/..
    try $PYTHON_BASE/bin/python${VERSION_python} -m venv stage
    push_env
    # install pip and some default stuff
    pip3 install --upgrade pip
    pip3 install --upgrade setuptools
    pip3 install --upgrade wheel
    pop_env
  fi

  # create build directory if not found
  test -d $PACKAGES_PATH || mkdir -p $PACKAGES_PATH
  test -d $BUILD_PATH || mkdir -p $BUILD_PATH
  test -d $STAGE_PATH/lib || mkdir -p $STAGE_PATH/lib
  test -d $QGIS_SITE_PACKAGES_PATH || mkdir -p $QGIS_SITE_PACKAGES_PATH
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
      error "Recipe $module does not exist"
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
  push_env
  cd $ROOT_PATH
  MODULES="$($PYTHON tools/depsort.py --optional $fn_optional_deps < $fn_deps)"
  pop_env

  info "Modules changed to $MODULES"
}

function download_file() {
    module=$1
    url=$2
    md5=$3

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
      return
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

    url="URL_$module"
    url=${!url}
    md5="MD5_$module"
    md5=${!md5}

    # if string is empty means we do not need to download anything
    if [ "X$url" == "X" ]; then
      debug "$module does not specified download URL, skipping"
      continue
    fi

    # check if the URL is the path on disk - do not do anything in that case
    if [ -d "$url" ]; then
      debug "$module specified directory on disk $url"
      continue
    fi

    debug "Download package for $module"
    download_file $module $url $md5
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
  run_final_check
  info "All done !"
}

function list_modules() {
  modules=$(find recipes -iname 'recipe.sh' | cut -d/ -f2 | sort -u | xargs echo)
  echo "Available modules: $modules"
  exit 0
}

# run_final_check
# exit 0;

# Do the build
while getopts ":hBvlfxic:m:u:s:g" opt; do
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
    c)
      push_env
      eval $OPTARG
      pop_env
      exit 0
      ;;
    B)
      push_env
      open $QT_BASE/../Qt\ Creator.app
      pop_env
      exit 0
      ;;
    u)
      MODULES_UPDATE="$OPTARG"
      ;;
    f)
      builds/qgis-deps-0.1.0/build/=1
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
