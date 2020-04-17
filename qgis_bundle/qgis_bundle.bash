#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Bundling QGIS"
else
  echo "Unable to bundle QGIS binaries on $OSTYPE"
  exit 1;
fi

# Internals
CRED="\x1b[31;01m"
CBLUE="\x1b[34;01m"
CGRAY="\x1b[30;01m"
CRESET="\x1b[39;49;00m"

function try () {
    "$@" || exit -1
}

function info() {
  echo -e "$CBLUE"$@"$CRESET";
}

function error() {
  MSG="$CRED"$@"$CRESET"
  echo -e $MSG;
  exit -1
}

function debug() {
  echo -e "$CGRAY"$@"$CRESET";
}

function install_name_change {

  if [ ! -f "$3" ]; then
    error "Missing $3 (install_name_change)"
  fi
  install_name_tool -change $1 $2 $3
}

function install_name_id {

  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_id)"
  fi
  install_name_tool -id $1 $2
}

source `dirname $0`/../qgis_deps/config.conf
if [ -d $ROOT_OUT_PATH/stage ]; then
       info "Using qgis_deps: $ROOT_OUT_PATH/stage"
else
       error "Missing qgis_deps directory '$ROOT_OUT_PATH/stage' not found."
fi

source $ROOT_OUT_PATH/stage/qgis-deps.config

# FIND all modules - the order does not matter here
MODULES=
for dir in `dirname $0`/recipes/*/
do
    dir=${dir%*/}
    MODULES="$MODULES ${dir##*/}"
done


# From step qgis_deps
export STAGE_PATH=$ROOT_OUT_PATH/stage
export RECIPES_PATH=$DIR/recipes

export DEPS_ROOT_DIR=$STAGE_PATH
export DEPS_FRAMEWORKS_DIR=$STAGE_PATH/Frameworks
export DEPS_SHARE_DIR=$STAGE_PATH/share
export DEPS_BIN_DIR=$STAGE_PATH/bin
export DEPS_LIB_DIR=$STAGE_PATH/lib
export DEPS_PYTHON_SITE_PACKAGES_DIR=$STAGE_PATH/lib/python${VERSION_major_python}

if [ ! -d $DEPS_PYTHON_SITE_PACKAGES_DIR ]; then
       error "Missing DEPS_PYTHON_SITE_PACKAGES_DIR directory '$DEPS_PYTHON_SITE_PACKAGES_DIR'"
fi

export QGIS_DEPS_LIB
# From step qgis_build
export QGIS_VERSION=3.13
export QGIS_BUILD_DIR=$ROOT_OPT_PATH/qgis-${QGIS_VERSION}-deps-${RELEASE_VERSION}/build
export QGIS_INSTALL_DIR=$ROOT_OPT_PATH/qgis-${QGIS_VERSION}-deps-${RELEASE_VERSION}/install

if [ ! -d $QGIS_INSTALL_DIR ]; then
       error "Missing QGIS directory 'QGIS_INSTALL_DIR: $QGIS_INSTALL_DIR'"
fi

# From step qgis_bundle

export APPLICATION_PATH=/Applications/QGIS-${QGIS_VERSION}

export BUNDLE_DIR=$ROOT_OPT_PATH/qgis-${QGIS_VERSION}-deps-${RELEASE_VERSION}/bundle
export BUNDLE_CONTENTS_DIR=$BUNDLE_DIR/QGIS.app/Contents
export BUNDLE_FRAMEWORKS_DIR=$BUNDLE_CONTENTS_DIR/Frameworks
export BUNDLE_RESOURCES_DIR=$BUNDLE_CONTENTS_DIR/Resources
export BUNDLE_MACOS_DIR=$BUNDLE_CONTENTS_DIR/MacOS
export BUNDLE_BIN_DIR=$BUNDLE_MACOS_DIR/bin
export BUNDLE_PLUGINS_DIR=$BUNDLE_CONTENTS_DIR/PlugIns
export BUNDLE_LIB_DIR=$BUNDLE_MACOS_DIR/lib
export BUNDLE_PYTHON_SITE_PACKAGES_DIR=$BUNDLE_RESOURCES_DIR/python

export RPATH_LIB_DIR=@rpath


# COMMANDS
RSYNCDIR="rsync -r"
CP=cp

function env_var_exists() {
  VAR=$1
  if [ "X$VAR" == "X" ]; then
     error "Missing config variable $VAR"
  fi
}

function run_prepare_bundle_dir() {
  rm -rf $BUNDLE_DIR
  mkdir -p $BUNDLE_DIR
  mkdir -p $BUNDLE_CONTENTS_DIR
  mkdir -p $BUNDLE_FRAMEWORKS_DIR
  mkdir -p $BUNDLE_RESOURCES_DIR
  mkdir -p $BUNDLE_MACOS_DIR
  mkdir -p $BUNDLE_BIN_DIR
  mkdir -p $BUNDLE_PLUGINS_DIR
  mkdir -p $BUNDLE_LIB_DIR
}

function run_check() {
  for module in ${MODULES[*]}; do
    fn=$(echo check_$module)
    debug "Call $fn"
    $fn
  done
}

function run_bundle() {
  for module in ${MODULES[*]}; do
    fn=$(echo bundle_$module)
    debug "Call $fn"
    $fn
  done
}

function run_postbundle() {
  for module in ${MODULES[*]}; do
    fn=$(echo postbundle_$module)
    debug "Call $fn"
    $fn
  done
}

function run_source_modules() {
  for module in ${MODULES[*]}; do
    source $RECIPES_PATH/$module/recipe.sh
  done
}

function run_add_config_info() {
  for module in ${MODULES[*]}; do
    fn=$(echo add_config_info_$module)
    debug "Call $fn"
    $fn
  done
}

function check_binary_linker_links() {
  cd ${BUNDLE_DIR}
  OTOOL_L=$(otool -L $1)
  OTOOL_RPATH=$(otool -l $1)

  if echo "${OTOOL_L}" | grep -q /usr/local/
  then
    echo "${OTOOL_L}"
    error "$1 contains /usr/local/ string <-- Picked some homebrew libraries!"
  fi

  if echo "${OTOOL_L}"  | grep -q $QGIS_INSTALL_DIR
  then
    echo "${OTOOL_L}"
    error "$1 contains $QGIS_INSTALL_DIR string <-- forgot to change install_name for the linked library?"
  fi

  if echo "${OTOOL_L}"  | grep -q $STAGE_PATH
  then
    echo "${OTOOL_L}"
    echo "$1 contains $STAGE_PATH string <-- forgot to change install_name for the linked library?"
  fi

  if echo ${OTOOL_L} | grep -q $BUNDLE_DIR
  then
    echo "${OTOOL_L}"
    echo "$1 contains $BUNDLE_DIR string <-- forgot to change install_name for the linked library?"
  fi

  targets=(
    libz
    libssl
    libcrypto
    libpq
    libexpat
    libiconv
    libxml2
    libsqlite3
  )

  for i in ${targets[*]}
  do
      if echo "${OTOOL_L}" | grep -q /usr/lib/$i.dylib
      then
        echo "${OTOOL_L}"
        error "$1 contains /usr/lib/$i.dylib string -- we should be using our $i, not system!"
      fi
  done
}

run_final_check() {
  info "Running final check in the ${BUNDLE_DIR}"

  # libs
  info "Check libraries"
  cd ${BUNDLE_DIR}
  LIBS1=`find . -type f -name "*.so"`
  LIBS2=`find . -type f -name "*.dylib"`
  LIBS="$LIBS1 $LIBS2"
  for lib in $LIBS; do
    check_binary_linker_links $lib
  done

  info "Check binaries"
  # frameworks (Mach-O without binaries)
  LIBS=`find . -type f ! -name "*.*"`
  for lib in $LIBS; do
    attachmenttype=$(file ${STAGE_PATH}/bin/$lib | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      check_binary_linker_links $lib
    fi
  done

  info "Check other files"
  # all other files
  if grep -rni $BUNDLE_DIR .
  then
    grep -rni $STAGE_PATH $STAGE_PATH
    error "Some scripts reference absolute BUNDLE_DIR dir $BUNDLE_DIR"
  fi
}

function run() {
  run_prepare_bundle_dir
  run_source_modules
  run_check
  run_bundle
  run_postbundle
  run_add_config_info
  run_final_check
  info "All done !"
}

run