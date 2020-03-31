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

# From step qgis_build
export QGIS_VERSION=3.13
export QGIS_INSTALL_DIR=$ROOT_OUT_PATH/../qgis/stage/QGIS-${QGIS_VERSION}-deps-${RELEASE_VERSION}
if [ ! -d $QGIS_INSTALL_DIR ]; then
       error "Missing QGIS directory 'QGIS_INSTALL_DIR: $QGIS_INSTALL_DIR'"
fi

# From step qgis_bundle
export APPLICATION_PATH=/Applications/QGIS-NEW
export BUNDLE_DIR=$ROOT_OUT_PATH/../qgis/bundle/QGIS-${QGIS_VERSION}-deps-${RELEASE_VERSION}
export BUNDLE_CONTENTS_DIR=$BUNDLE_DIR/QGIS.app/Contents
export BUNDLE_FRAMEWORKS_DIR=$BUNDLE_CONTENTS_DIR/Frameworks
export BUNDLE_RESOURCES_DIR=$BUNDLE_CONTENTS_DIR/Resources
export BUNDLE_MACOS_DIR=$BUNDLE_CONTENTS_DIR/MacOS
export BUNDLE_BIN_DIR=$BUNDLE_MACOS_DIR/bin
export BUNDLE_PLUGINS_DIR=$BUNDLE_MACOS_DIR/PlugIns
export BUNDLE_LIB_DIR=$BUNDLE_MACOS_DIR/lib

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

function check_linked_rpath() {
  cd ${STAGE_PATH}
  if otool -L $1 | grep -q /usr/local/lib
  then
    otool -L $1
    error "$1 contains /usr/local/lib string <-- Picked some homebrew libraries!"
  fi

  if otool -L $1 | grep -q $ROOT_OUT_PATH
  then
    otool -L $1
    error "$1 contains $ROOT_OUT_PATH string <-- forgot to change install_name for the linked library?"
  fi

  # if otool -L $1 | grep -q @rpath/lib/
  # then
  #  otool -L $1
  #  info "$1 contains  @rpath/lib string <-- typo in the receipt, should be without lib"
  #fi

  #if otool -L $1 | grep -q @rpath
  #then
  #  otool -L $1
  #  info "$1 contains  @rpath string <-- typo in the receipt, should not use rpath"
  #fi

  targets=(
    libz
    libssl
    libcrypto
    libpq
    lib
    libxml2
    libsqlite3
  )
  for i in ${targets[*]}
  do
      if otool -L $1 | grep -q /usr/lib/$i.dylib
      then
        otool -L $1
        info "$1 contains /usr/lib/$i.dylib string -- we should be using our $i, not system!"
      fi
  done
}

function verify_lib() {
  cd ${STAGE_PATH}/

  if [ ! -f "lib/$1" ]; then
       debug "Missing library: ${STAGE_PATH}/lib/$1"
  fi

  LIB_ARCHS=`lipo -archs lib/$1`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library lib/$1 was not successfully build for $ARCH, but ${LIB_ARCHS}"
  fi

  check_linked_rpath lib/$1
}

function verify_bin() {
  cd ${STAGE_PATH}/

  if [ ! -f "bin/$1" ]; then
       debug "Missing binary: ${STAGE_PATH}/bin/$1"
  fi

  LIB_ARCHS=`lipo -archs bin/$1`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Executable bin/$1 was not successfully build for $ARCH, but ${LIB_ARCHS}"
  fi

  check_linked_rpath bin/$1

  # check that the binary has the rpath to the lib folder
  # if otool -l bin/$1 |grep -q "@executable_path/../lib"
  # then
    : # OK!
  # else
  #  otool -l bin/$1
  #  error "Executable bin/$1 does not contain rpath to lib folder $STAGE_PATH string <-- forgot to add to receipt: install_name_tool -add_rpath @executable_path/../lib bin/$1 ? "
  #fi

  # check that the binary has the rpath to the lib folder
  #if otool -l bin/$1 |grep -q "$ROOT_OUT_PATH"
  #then
  #  otool -l bin/$1
  #  error "Executable bin/$1 does contain rpath to lib folder $ROOT_OUT_PATH string <-- forgot to add to receipt: install_name_tool -delete_rpath @executable_path/../lib bin/$1 ? "
  #fi

  # check that the binary that links QT has the QT rpath
  #if otool -L bin/$1 |grep -q "@rpath/Qt"
  #then
  #  if otool -l bin/$1 |grep -q "$QT_BASE/clang_64/lib"
  #  then
  #    : # OK!
  #  else
  #    otool -l bin/$1
  #    error "Executable bin/$1 does contain rpath to QT folder $QT_BASE/clang_64/lib <-- forgot to add to receipt: install_name_tool -add_rpath \$QT_BASE/clang_64/lib bin/$1 ? "
  #  fi
  #fi
}

run_final_check() {
  info "Running final check in the ${BUNDLE_DIR}"

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

  cd ${STAGE_PATH}/Frameworks
  LIBS=`find . -type f ! -name "*.*"`
  for lib in $LIBS; do
    attachmenttype=$(file ${STAGE_PATH}/bin/$lib | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      verify_lib $lib
    fi
  done

  info "Running final check for all binaries in the ${STAGE_PATH}/bin"
  # binaries
  mkdir -p ${STAGE_PATH}/bin
  cd ${STAGE_PATH}/bin
  EXEC=`find . -type f -name "*" ! -name "sip" ! -name "pip*" ! -name "activate*" ! -name "easy_install*" ! -name "python*"`
  for bin in $EXEC; do
    attachmenttype=$(file ${STAGE_PATH}/bin/$bin | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      verify_bin $bin
    fi
  done

  # all other files
  #if grep -rni $STAGE_PATH $STAGE_PATH --exclude-dir=__pycache__
  #then
  #  grep -rni $STAGE_PATH $STAGE_PATH --exclude-dir=__pycache__
  #  error "Some scripts reference absolute STAGE_PATH dir $STAGE_PATH"
  #fi
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