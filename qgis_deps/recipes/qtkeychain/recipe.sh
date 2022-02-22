#!/bin/bash

DESC_qtkeychain="Platform-independent Qt API for storing passwords securely"


LINK_qtkeychain=libqt5keychain.1.dylib

DEPS_qtkeychain=()


# md5 of the package

# default build path
BUILD_qtkeychain=${DEPS_BUILD_PATH}/qtkeychain/$(get_directory $URL_qtkeychain)

# default recipe path
RECIPE_qtkeychain=$RECIPES_PATH/qtkeychain

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtkeychain() {
  cd $BUILD_qtkeychain


}

function shouldbuild_qtkeychain() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_qtkeychain -nt $BUILD_qtkeychain/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_qtkeychain() {
  verify_binary lib/$LINK_qtkeychain
}

# function to append information to config file
function add_config_info_qtkeychain() {
  append_to_config_file "# qtkeychain-${VERSION_qtkeychain}: ${DESC_qtkeychain}"
  append_to_config_file "export VERSION_qtkeychain=${VERSION_qtkeychain}"
  append_to_config_file "export LINK_qtkeychain=${LINK_qtkeychain}"
}