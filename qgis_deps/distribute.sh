#!/usr/bin/env bash

# set -x
#set -e

set -o pipefail


source ../scripts/utils.sh

function pop_env() {
  info "Leaving build environment"

  export PATH=${OLD_PATH}
  export CFLAGS=${OLD_CFLAGS}
  export CXXFLAGS=${OLD_CXXFLAGS}
  export LDFLAGS=${OLD_LDFLAGS}
  export CC=${OLD_CC}
  export CXX=${OLD_CXX}
  export MAKESMP=${OLD_MAKESMP}
  export NINJA=${OLD_NINJA}
  export MAKE=${OLD_MAKE}
  export LD=${OLD_LD}
  export CMAKE=${OLD_CMAKE}
  export CONFIGURE=${OLD_CONFIGURE}
  export INCLUDE=${OLD_INCLUDE}
  export LIB_DIR=${OLD_LIB_DIR}
  export LIB=${OLD_LIB}
  export SYSROOT=${OLD_SYSROOT}
  export PYTHON=${OLD_PYTHON}
  export DYLD_LIBRARY_PATH=${OLD_DYLD_LIBRARY_PATH}
  export DYLD_FALLBACK_LIBRARY_PATH=OLD_DYLD_FALLBACK_LIBRARY_PATH
  export LD_LIBRARY_PATH=${OLD_LD_LIBRARY_PATH}
  export PIP=${OLD_PIP}
  export QSPEC=${OLD_QSPEC}
  export PKG_CONFIG_PATH=${OLD_PKG_CONFIG_PATH}
  unset DYLD_INSERT_LIBRARIES
}

#########################################################################################################
echo "Loading configuration"
#########################################################################################################

XCODE_DEVELOPER="$(xcode-select -print-path)"
export CORES=$(sysctl -n hw.ncpu)
ARCH=x86_64
DO_CLEAN_BUILD=0
DO_SET_X=0
DEBUG=0


# Load configuration
QGIS_DEPS_RELEASE_VERSION=${1}
if [ -z ${QGIS_DEPS_RELEASE_VERSION} ]; then
  usage
  exit 1
fi
CONFIG_FILE="config/deps-${QGIS_DEPS_RELEASE_VERSION}.conf"
if [[ ! -f "${CONFIG_FILE}" ]]; then
  error "invalid config file ${CONFIG_FILE}"
fi
shift

source ${CONFIG_FILE}

source versions.conf

SOURCE_PACKAGES_PATH=${SOURCE_PACKAGES_PATH:-${ROOT_OUT_PATH}/.packages}


if [[ -z ${QGIS_DEPS_RELEASE_VERSION} ]]; then
  error "you need at QGIS_DEPS_RELEASE_VERSION in config.conf"
fi

if [[ -z ${MACOSX_DEPLOYMENT_TARGET} ]]; then
  error "you need at MACOSX_DEPLOYMENT_TARGET in config.conf"
fi

if [[ -z ${VERSION_QT} ]]; then
  error "No VERSION_QT environment set, abort"
fi

if [[ -z ${QT_BASE} ]]; then
  error "No QT_BASE environment set, abort"
fi

if [ -f "${QT_BASE}/clang_64/bin/qmake" ]; then
   debug "Using QT: ${QT_BASE}"
else
   error "The file '${QT_BASE}/clang_64/bin/qmake' in not found."
fi

if [[ -z ${ROOT_OUT_PATH} ]]; then
  error "No ROOT_OUT_PATH environment set, abort"
fi

if [ -d ${ROOT_OUT_PATH} ]; then
   debug "Using root output path: ${ROOT_OUT_PATH}"
else
   error "The root output directory '${ROOT_OUT_PATH}' not found."
fi

# override error function to use pop_env
function error() {
  MSG="${CRED}"$@"${CRESET}"
  pop_env
  echo -e ${MSG};
  exit 1
}

# Paths
ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RECIPES_PATH="${ROOT_PATH}/recipes"
QGIS_SITE_PACKAGES_PATH=${STAGE_PATH}/lib/python${VERSION_major_python}/site-packages
BUILD_CONFIG_FILE="${STAGE_PATH}/qgis-deps.config"

function add_homebrew_path() {
   # info "Adding /usr/local/opt/${1}/bin to PATH"
   if [ ! -d "/usr/local/opt/${1}/bin" ]; then
     error "Missing homebrew ${1} /usr/local/opt/${1}/bin"
   fi
   export PATH="/usr/local/opt/${1}/bin:${PATH}"
}

function check_file_configuration() {
  # "Checking ${1} for /usr/local/lib"
  if grep -q /usr/local/lib ${1}
  then
    info "Found: "
    cat ${1} | grep /usr/local/lib
    error "File ${1} contains /usr/local/lib string <-- CMake picked some homebrew libs!"
  fi

  targets=(
    openssl
    openssl@1.1
    gettext
    libunistring
    xz
  )
  for i in ${targets[*]}
  do
    if grep -q /usr/local/opt/${i}/lib ${1}
    then
      info "Found: "
      cat ${1} | grep /usr/local/opt/${i}/lib
      error "File ${1} contains /usr/local/${i}/lib string <-- CMake picked some homebrew libs!"
    fi
  done
}

function python_package_installed() {
  cd ${STAGE_PATH}

  python_import=${1}
  verbose=${2}

  push_env

  if ${PYTHON} -c import\ ${python_import} > /dev/null 2>&1
  then
    pop_env
    return 0
  fi

  if [ "X${verbose}" == "Xverbose" ]; then
    ${PYTHON} -c import\ ${python_import}
  fi

  pop_env
  return 1
}

function python_package_installed_verbose() {
  python_package_installed ${1} verbose
  return $?
}

function patch_configure_file() {
    try ${SED} 's;/usr/local/lib/ ;;g' ${1}
    try ${SED} 's; /usr/local/lib/;;g' ${1}
    try ${SED} 's;/usr/local/lib/;;g' ${1}
    try ${SED} 's; /usr/local/lib;;g' ${1}
    try ${SED} 's;/usr/local/lib ;;g' ${1}
    try ${SED} 's;/usr/local/lib;;g' ${1}
}

function patch_qmake_pri_file() {
  # Install in stage path
  try ${SED} "s;QWT_INSTALL_PREFIX.*=.*;QWT_INSTALL_PREFIX=${STAGE_PATH};g" ${1}

  # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`
  try ${SED} "s;= \$\${QWT_INSTALL_PREFIX}/plugins/designer;=${STAGE_PATH}/lib/qt/plugins/designer;g" ${1}
}

function push_env() {
    info "Entering in build environment"

    export OLD_PATH=${PATH}
    export OLD_CFLAGS=${CFLAGS}
    export OLD_CXXFLAGS=${CXXFLAGS}
    export OLD_LDFLAGS=${LDFLAGS}
    export OLD_CC=${CC}
    export OLD_CXX=${CXX}
    export OLD_MAKESMP=${MAKESMP}
    export OLD_MAKESMP_INSTALL=${MAKESMP_INSTALL}
    export OLD_MAKE=${MAKE}
    export OLD_LD=${LD}
    export OLD_CMAKE=${CMAKE}
    export OLD_CONFIGURE=${CONFIGURE}
    export OLD_INCLUDE=${INCLUDE}
    export OLD_LIB_DIR=${LIB_DIR}
    export OLD_LIB=${LIB}
    export OLD_SYSROOT=${SYSROOT}
    export OLD_PYTHON=${PYTHON}
    export OLD_DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}
    export OLD_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
    export OLD_DYLD_FALLBACK_LIBRARY_PATH=DYLD_FALLBACK_LIBRARY_PATH
    export OLD_PIP=${PIP}
    export OLD_QSPEC=${QSPEC}
    export OLD_NINJA=${NINJA}
    export OLD_NINJA_INSTALL=${NINJA_INSTALL}
    export OLD_PKG_CONFIG_PATH=${PKG_CONFIG_PATH}

    ###################
    # Path
    export PATH="/sbin/:/bin/:/usr/bin"

    add_homebrew_path cmake
    add_homebrew_path ninja
    add_homebrew_path coreutils
    add_homebrew_path ccache
    add_homebrew_path autoconf
    add_homebrew_path automake
    add_homebrew_path libtool
    add_homebrew_path pkg-config
    add_homebrew_path help2man
    add_homebrew_path git
    add_homebrew_path wget
    add_homebrew_path texinfo
    add_homebrew_path rust

    ###################
    # Configure/Make system
    export CFLAGS="-I${STAGE_PATH}/include"
    export LDFLAGS="-L${STAGE_PATH}/lib"
    export CXXFLAGS="${CFLAGS}"

    export PATH="${PATH}:${XCODE_DEVELOPER}/usr/bin:${STAGE_PATH}/bin:${QT_BASE}/clang_64/bin"

    # export some tools
    export MAKESMP="/usr/bin/make -j${CORES}"
    export MAKE="/usr/bin/make"
    export CONFIGURE="./configure --prefix=${STAGE_PATH}"
    export CC="/usr/bin/clang"
    export CXX="/usr/bin/clang++"
    export NINJA="/usr/local/bin/ninja"
    export LD="/usr/bin/ld"
    export PKG_CONFIG_PATH=${STAGE_PATH}/lib/pkgconfig

    ###################
    # CMake
    export LIB=${STAGE_PATH}
    export INCLUDE=${STAGE_PATH}/include
    export LIB_DIR=${STAGE_PATH}

    CMAKE="cmake"
    if [ ${DEBUG} -eq 1 ]; then
      echo "!!!!!BUILDING DEBUG LIBRARIES!!!!!"
      CMAKE="${CMAKE} -DCMAKE_BUILD_TYPE=Debug"
    else
      CMAKE="${CMAKE} -DCMAKE_BUILD_TYPE=Release"
    fi
    export CMAKE="${CMAKE} -DCMAKE_INSTALL_PREFIX:PATH=${STAGE_PATH}"
    export CMAKE="${CMAKE} -DCMAKE_PREFIX_PATH=${STAGE_PATH};${QT_BASE}/clang_64"
    export CMAKE="${CMAKE} -DCMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH=FALSE"
    export CMAKE="${CMAKE} -DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=FALSE"
    export CMAKE="${CMAKE} -DCMAKE_MACOSX_RPATH=OFF"
    export CMAKE="${CMAKE} -DENABLE_TESTS=OFF"
    export CMAKE="${CMAKE} -GNinja -DCMAKE_MAKE_PROGRAM=${NINJA}"
    # MACOSX_DEPLOYMENT_TARGET in environment should set minimum version

    ###################
    # QMAKE
    # use run_qmake in the receipts
    export QSPEC="macx-clang"
    export QMAKE="qmake -config release -spec ${QSPEC}"

    ###################
    # PYTHON
    export PYTHON="${STAGE_PATH}/bin/python3"
    export PIP="${STAGE_PATH}/bin/pip3 --trusted-host pypi.org"

    export PIP_NO_BINARY="${PIP} install --no-dependencies --no-binary all --global-option=build_ext"
    export PIP_NO_BINARY="${PIP_NO_BINARY} --global-option=--include-dirs=${STAGE_PATH}/include"
    export PIP_NO_BINARY="${PIP_NO_BINARY} --global-option=--library-dirs=${STAGE_PATH}/lib"
}

#########################################################################################################
info "Check mandatory tools"
#########################################################################################################
push_env
MD5SUM=$(which md5sum)
if [[ -z ${MD5SUM} ]]; then
  MD5SUM=$(which md5)
  if [[ -z ${MD5SUM} ]]; then
    error "you need at least md5sum or md5 installed."
  else
    MD5SUM="${MD5SUM} -r"
  fi
fi

WGET=$(which wget)
if [[ -z ${WGET} ]]; then
  WGET=$(which curl)
  if [[ -z ${WGET} ]]; then
    error "you need at least wget or curl installed."
  else
    WGET="${WGET} -L -o"
  fi
else
  WGET="${WGET} -q -O"
fi

for tool in tar bzip2 unzip cmake bison flex autoconf automake libtool pkg-config autoreconf perl python3; do
  which ${tool} &>/dev/null
  if [ $? -ne 0 ]; then
    error "Tool ${tool} is missing"
  fi
done
pop_env

#########################################################################################################
#########################################################################################################
#########################################################################################################

function get_directory() {
  case ${1} in
    *.tar.gz) directory=$(basename ${1} .tar.gz) ;;
    *.tar.lz) directory=$(basename ${1} .tar.lz) ;;
    *.tgz)    directory=$(basename ${1} .tgz) ;;
    *.tar.bz2)  directory=$(basename ${1} .tar.bz2) ;;
    *.tbz2)   directory=$(basename ${1} .tbz2) ;;
    *.zip)    directory=$(basename ${1} .zip) ;;
    *.tar.xz) directory=$(basename ${1} .tar.xz) ;;
    *)
      error "Unknown file extension ${1}"
      ;;
  esac
  echo ${directory}
}


function check_linked_rpath() {
  cd ${STAGE_PATH}
  if otool -L ${1} | grep -q /usr/local
  then
    otool -L ${1}
    error "${1} contains /usr/local string <-- CMake picked some homebrew libs!"
  fi

  # the binaries cannot contain reference to build path since this path is not present when
  # the deps are downloaded from the web
  if otool -L ${1} | grep -q ${DEPS_BUILD_PATH}
  then
    otool -L ${1}
    error "${1} contains ${DEPS_BUILD_PATH} string <-- forgot to change install_name for the linked library?"
  fi

  targets=(
    libz
    libssl
    libcrypto
    libpq
    libxml2
    libsqlite3
    libexpat
    liblzma
    libbz2
    libiodbc
    libcurl
  )
  for i in ${targets[*]}
  do
      if otool -L ${1} | grep -q /usr/lib/${i}.dylib
      then
        otool -L ${1}
        info "${1} contains /usr/lib/${i}.dylib string"
      fi
  done
}

function verify_binary() {
  BINARY=${1}
  cd ${STAGE_PATH}/

  if [ ! -f "${BINARY}" ]; then
    error "Missing library: ${STAGE_PATH}/${BINARY}... Maybe you updated the library version in the receipt?"
  fi

  LIB_ARCHS=`lipo -archs ${BINARY}`
  if [[ ${LIB_ARCHS} != *"${ARCH}"* ]]; then
    error "Binary ${BINARY} was not successfully build for ${ARCH}, but ${LIB_ARCHS}"
  fi

  check_linked_rpath ${BINARY}
}

function test_binary_output() {
  BINARY=${1}
  OUTPUT=${2}
  cd ${STAGE_PATH}/

  BINOUT=`${BINARY}`
  if [[ ${BINOUT} == *"${OUTPUT}"* ]]; then
    # OK found expected string in binary output
    :
  else
    echo "-raw-output-of-${BINARY}--"
    echo ${BINOUT}
    echo "------"
    error "Output of ${BINARY} does not contain ${OUTPUT}"
  fi
}


function run_prepare()
{
  if [[ -z ${MODULES} ]]; then
    usage
    exit 0
  fi

  if [ ${DO_CLEAN_BUILD} -eq 1 ]; then
    info "Cleaning build"
    try rm -rf ${STAGE_PATH}
    try rm -rf ${DEPS_BUILD_PATH}
  fi

  info "Distribution will be located at ${STAGE_PATH}"
  if [ -e "${STAGE_PATH}" ]; then
    info "The directory ${STAGE_PATH} already exist"
    info "Will continue using and possibly overwrite what is in there"
  else
    try mkdir -p "${STAGE_PATH}"
  fi

  # create build directory if not found
  test -d ${SOURCE_PACKAGES_PATH} || mkdir -p ${SOURCE_PACKAGES_PATH}
  test -d ${DEPS_BUILD_PATH} || mkdir -p ${DEPS_BUILD_PATH}
  test -d ${STAGE_PATH}/lib || mkdir -p ${STAGE_PATH}/lib
  test -d ${STAGE_PATH}/Frameworks || mkdir -p ${STAGE_PATH}/Frameworks
}

function in_array() {
  term="${1}"
  shift
  i=0
  for key in $@; do
    if [ ${term} == ${key} ]; then
      echo ${i}
      return
    fi
    i=$((${i} + 1))
  done
  echo -1
  return
}

function run_source_modules() {
  # preprocess version modules
  needed=(${MODULES})
  while [ ${#needed[*]} -ne 0 ]; do

    # pop module from the needed list
    module=${needed[0]}
    unset needed[0]
    needed=( ${needed[@]} )
  done

  needed=(${MODULES})
  declare -a processed
  processed=()

  fn_deps=${DEPS_BUILD_PATH}'/.deps'
  fn_optional_deps=${DEPS_BUILD_PATH}'/.optional-deps'

  > ${fn_deps}
  > ${fn_optional_deps}

  while [ ${#needed[*]} -ne 0 ]; do
    # pop module from the needed list
    module=${needed[0]}
    original_module=${needed[0]}
    unset needed[0]
    needed=( ${needed[@]} )

    # check if the module have already been declared
    if [[ $(in_array ${module} "${processed[@]}") -ne -1 ]]; then
      # debug "Ignored ${module}, already processed"
      continue;
    fi

    # add this module as done
    processed=( ${processed[@]} ${module} )

    # read recipe
    #debug "Read ${module} recipe"
    recipe=${RECIPES_PATH}/${module}/recipe.sh
    if [ ! -f ${recipe} ]; then
      error "Recipe ${module} does not exist"
    fi
    source ${RECIPES_PATH}/${module}/recipe.sh

    # append current module deps to the needed
    deps="DEPS_${module}[@]"
    deps=${!deps}
    optional_deps="DEPS_OPTIONAL_${module}[@]"
    optional_deps=${!optional_deps}
    if [ ${#deps[*]} -gt 0 ]; then
      #debug "Module ${module} depends on" ${deps[@]}
      needed=( ${needed[@]} ${deps[@]} )
      echo ${module} ${deps[@]} >> ${fn_deps}
    else
      echo ${module} >> ${fn_deps}
    fi
    if [ ${#optional_deps[*]} -gt 0 ]; then
      echo ${module} ${optional_deps[@]} >> ${fn_optional_deps}
    fi
  done

  info $(pwd)
  push_env
  cd ${ROOT_PATH}
  MODULES="$(python3 tools/depsort.py --optional ${fn_optional_deps} < ${fn_deps})"
  pop_env

  info "Modules changed to ${MODULES}"

  UNUSED_MODULES=()
  for d in $(find ${RECIPES_PATH} -type d -d 1); do
    mod=$(echo "${d}" | gsed "s|${RECIPES_PATH}/||")
    if [[ ! " ${MODULES} " =~ " ${mod} " ]]; then
      UNUSED_MODULES+=("${mod}")
    fi
  done
  debug "Unused modules: ${UNUSED_MODULES[@]}"
}

function recipe_has_changed(){
  module=${1}
  file=${2}
  current_recipe_sum=$(${MD5SUM} ${RECIPES_PATH}/${module}/${file}.sh | cut -d\  -f1)
  if [[ -f ${DEPS_BUILD_PATH}/${module}/.${file} ]]; then
    stored_recipe_sum=$(cat ${DEPS_BUILD_PATH}/${module}/.${file})
    if [[ "${current_recipe_sum}" == "${stored_recipe_sum}" ]]; then
      echo 0
    fi
  fi
  echo 1
}

function download_file() {
    d_module=${1}
    d_url=${2}
    d_md5=${3}
    do_prebuild=${4}

    if [ ! -d "${DEPS_BUILD_PATH}/${d_module}" ]; then
      try mkdir -p ${DEPS_BUILD_PATH}/${d_module}
    fi

    if [ ! -d "${SOURCE_PACKAGES_PATH}/${d_module}" ]; then
      try mkdir -p "${SOURCE_PACKAGES_PATH}/${d_module}"
    fi

    if [[ -z ${d_url} ]]; then
      debug "No package for ${d_module}"
      return
    fi

    filename=$(basename ${d_url})

    marker_filename=".mark-${filename}"
    do_download=1

    cd "${SOURCE_PACKAGES_PATH}/${d_module}"

    # check if the file is already present
    if [ -f ${filename} ]; then
      # if the marker has not been set, it might be cause of an invalid download.
      if [ ! -f ${marker_filename} ]; then
        rm ${filename}
      elif [ -n "${d_md5}" ]; then
        # check if the md5 is correct
        current_md5=$(${MD5SUM} ${filename} | cut -d\  -f1)
        if [ "${current_md5}" == "${d_md5}" ]; then
          # correct, no need to download
          do_download=0
        else
          # invalid download, remove the file
          error "Module ${d_module} has invalid md5 (${current_md5} vs ${d_md5}), redownload."
          rm "${filename}"
        fi
      else
        do_download=0
      fi
    fi

    # download if needed
    if [ ${do_download} -eq 1 ]; then
      info "Downloading ${d_url}"
      try rm -f ${marker_filename}
      try ${WGET} ${filename} ${d_url}
      touch ${marker_filename}
    else
      debug "Module ${d_module} already downloaded"
    fi

    # check md5
    if [[ -n "${d_md5}" ]]; then
      current_md5=$(${MD5SUM} ${filename} | cut -d\  -f1)
      if [[ "${current_md5}" != "${d_md5}" ]]; then
        error "File ${filename} md5 check failed (got ${current_md5} instead of ${d_md5})."
      fi
    fi

    source_directory=$(get_directory ${filename})
    build_directory=${DEPS_BUILD_PATH}/${d_module}/build-${ARCH}

    if ( [[ -d ${source_directory} ]] || [[ -d ${build_directory} ]] ) && [[ ${do_prebuild} -eq 1 ]] && ( [[ ${do_download} -eq 1 ]] || [[ "$(recipe_has_changed "${d_module}" recipe)" == "1" ]]); then
      info "Recipe has changed, removing the existing source and build directories"
      rm ${DEPS_BUILD_PATH}/${module}/.build || true
      rm -rf ${DEPS_BUILD_PATH}/${d_module}/${source_directory}
      rm -rf ${build_directory}
    fi

    # if already decompress, forget it
    cd ${DEPS_BUILD_PATH}/${d_module}
    if [[ ! -d "${source_directory}" ]]; then
      # decompress
      pfilename=${SOURCE_PACKAGES_PATH}/${d_module}/${filename}
      info "Extract ${pfilename}"
      case ${pfilename} in
        *.tar.gz|*.tar.xz|*.tgz|*.tar.lz )
          try tar xzf ${pfilename}
          root_directory=$(basename $(try tar tzf ${pfilename}|head -n1))
          if [[ "${root_directory}" != "${source_directory}" ]]; then
            mv ${root_directory} ${source_directory}
          fi
          ;;
        *.tar.bz2|*.tbz2 )
          try tar xjf ${pfilename}
          root_directory=$(basename $(try tar tjf ${pfilename}|head -n1))
          if [[ "${root_directory}" != "${source_directory}" ]]; then
            mv ${root_directory} ${source_directory}
          fi
          ;;
        *.zip )
          try unzip ${pfilename}
          root_directory=$(basename $(try unzip -l ${pfilename}|sed -n 5p|awk '{print $4}'))
          if [[ "${root_directory}" != "${source_directory}" ]]; then
            mv ${root_directory} ${source_directory}
          fi
          ;;
      esac

      # run prebuild + patch
      if [[ ${do_prebuild} -eq 1 ]]; then
        fn="prebuild_${d_module}"
        debug "Call ${fn}"
        ${fn}
        recipe_sum=$(${MD5SUM} ${RECIPES_PATH}/${d_module}/recipe.sh | cut -d\  -f1)
        echo "${recipe_sum}" > ${DEPS_BUILD_PATH}/${d_module}/.recipe
      fi
    fi
}

function run_get_packages() {
  info "Run get packages"

  modules_arr=(${MODULES})
  nmod=${#modules_arr[@]}
  for (( j=0; j<nmod; j++ )); do
    module="${modules_arr[$j]}"
    fold_push "getting ${module} ($((j+1))/${nmod})"

    # download dependencies for this module
    # check if there is not an overload from environment
    module_dir="QGISDEPS_${module}_DIR"
    module_dir=${!module_dir}
    if [ "${module_dir}" ]; then
      debug "QGISDEPS_${module}_DIR is not empty, linking ${module_dir} dir instead of downloading"
      directory="BUILD_${module}"
      directory=${!directory}
      if [ -e ${directory} ]; then
        try rm -rf "${directory}"
      fi
      try mkdir -p "${directory}"
      try rmdir "${directory}"
      try ln -s "${module_dir}" "${directory}"
      continue
    fi

    url="URL_${module}"
    url=${!url}
    md5="MD5_${module}"
    md5=${!md5}

    # if string is empty means we do not need to download anything
    if [[ -z ${url} ]]; then
      debug "${module} does not specified download URL, skipping"
      continue
    fi

    # check if the URL is the path on disk - do not do anything in that case
    if [ -d "${url}" ]; then
      debug "${module} specified directory on disk ${url}"
      continue
    fi

    debug "Download package for ${module}"
    download_file ${module} ${url} ${md5} 1

    fold_pop
  done
}

function run_build() {
  info "Run build"

  modules_update=(${MODULES_UPDATE})

  cd ${DEPS_BUILD_PATH}

  modules_arr=(${MODULES})
  nmod=${#modules_arr[@]}
  for (( j=0; j<nmod; j++ )); do
    module="${modules_arr[$j]}"
    fold_push "building ${module} ($((j+1))/${nmod})"

    if [[ "$(recipe_has_changed "${module}" build)" == "1" ]]; then
      DO_BUILD=1
    elif [[ $(in_array ${module} "${modules_update[@]}") -ne -1 ]]; then
      debug "${module} detected to be updated"
      DO_BUILD=1
    else
      DO_BUILD=1
      if [[ -f ${DEPS_BUILD_PATH}/${module}/.build ]]; then
        info "${module} already built!"
        DO_BUILD=0
      fi
    fi

    # if the module should be build, or if the marker is not present,
    # do the build
    fn="build_${module}"
    if [[ "${DO_CLEAN_BUILD}" == "1" ]] ||  [[ "${DO_BUILD}" == "1" ]]; then
      debug "Call ${fn}"
      rm -f ${DEPS_BUILD_PATH}/${module}/.build
      source ${RECIPES_PATH}/${module}/build.sh
      # https://stackoverflow.com/a/363239/1548052
      if [[ ${CI} == true ]]; then
        echo "Building ${module}" > ${DEPS_BUILD_PATH}/last-build.log
        ${fn} >> ${DEPS_BUILD_PATH}/last-build.log
      else
        ${fn}
      fi
      [[ $? -ne 0 ]] && error "${module} build failed"
      echo "$module"
      build_sum=$(${MD5SUM} ${RECIPES_PATH}/${module}/build.sh | cut -d\  -f1)
      echo "${build_sum}" > ${DEPS_BUILD_PATH}/${module}/.build
    else
      debug "Skipped ${fn}"
    fi

    # postbuild
    fn2=$(echo postbuild_${module})
    debug "Call ${fn2}"
    if [[ ${CI} == true ]]; then
      echo "*** postbuild" > ${DEPS_BUILD_PATH}/last-build.log
      ${fn2} >> ${DEPS_BUILD_PATH}/last-build.log
    else
      ${fn2}
    fi
    [[ $? -ne 0 ]] && error "${module} postbuild failed"
    fold_pop
  done
}

function append_to_config_file() {
  echo "$@" >> ${BUILD_CONFIG_FILE}
}

function run_create_config_file() {
  info "Create ${BUILD_CONFIG_FILE}"
  rm -f ${BUILD_CONFIG_FILE}
  touch ${BUILD_CONFIG_FILE}

  append_to_config_file "export VERSION_major_python=${VERSION_major_python}"
  append_to_config_file "export VERSION_QT=${VERSION_QT}"
  append_to_config_file "export QT_BASE=${QT_BASE}"
  append_to_config_file "export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}"
  append_to_config_file "export QGIS_DEPS_SDK_VERSION=${QGIS_DEPS_SDK_VERSION}"

  cd ${DEPS_BUILD_PATH}
  for module in ${MODULES}; do
    fn=$(echo add_config_info_${module})
    debug "Call ${fn}"
    append_to_config_file " "
    ${fn}
  done
}

function list_modules() {
  modules=$(find recipes -iname 'recipe.sh' | cut -d/ -f2 | sort -u | xargs echo)
  echo "Available modules: ${modules}"
  exit 0
}

function usage() {
  echo "QGIS deps - distribute.sh"
  echo
  echo "Usage: ./distribute.sh deps_version [options]"
  echo "To build whole package, run:   ./distribute.sh 0.x -mqgis_deps"
  echo
  echo "  -h                     Show this help"
  echo "  -c                     Run command in the build environment"
  echo "  -l                     Show a list of available modules"
  echo "  -m 'mod1 mod2'         Modules to build"
  echo "  -d 'mod1 mod2'         Shows the list of modules to build, including dependencies"
  echo "  -f                     Clean build"
  echo "  -x                     display expanded values (execute 'set -x')"
  echo
  echo "For developers:"
  echo "  -u 'mod1 mod2'         Modules to update (if already compiled)"
  echo
  exit 0
}

# Do the build
while getopts ":hlfxc:d:m:u:" opt; do
  case ${opt} in
    h)
      usage
      ;;
    l)
      list_modules
      ;;
    g)
      DEBUG=1
      echo "Requesting debug binaries"
      ;;
    m)
      MODULES="${OPTARG}"
      ;;
    d)
      MODULES="${OPTARG}"
      run_prepare
      run_source_modules
      exit 0
      ;;
    c)
      push_env
      bash -c "${OPTARG}"
      pop_env
      exit 0
      ;;
    u)
      MODULES_UPDATE="${OPTARG}"
      ;;
    f)
      DO_CLEAN_BUILD=1
      ;;
    x)
      DO_SET_X=1
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "Option -${OPTARG} requires an argument." >&2
      exit 1
      ;;

    *)
      echo "=> ${OPTARG}"
      ;;
  esac
done

if [ ${DO_SET_X} -eq 1 ]; then
  info "Set -x for displaying expanded values"
  set -x
fi

cd ${ROOT_PATH}
fold_push prepare
run_prepare
fold_pop
fold_push source
run_source_modules
fold_pop
fold_push download
run_get_packages
fold_pop
fold_push build
run_build
fold_pop
fold_push create_config_file
run_create_config_file
fold_pop
info create deps config file
cp ${ROOT_PATH}/config/deps-${QGIS_DEPS_RELEASE_VERSION}.conf ${STAGE_PATH}/qgis-qeps-${QGIS_DEPS_RELEASE_VERSION}.conf
info "All done !"
