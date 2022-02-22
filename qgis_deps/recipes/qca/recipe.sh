#!/bin/bash

DESC_qca="Qt Cryptographic Architecture (QCA)"

LINK_qca=qca-qt5

DEPS_qca=(openssl)


# md5 of the package

# default build path
BUILD_qca=${DEPS_BUILD_PATH}/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
  cd $BUILD_qca


}

function shouldbuild_qca() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/$LINK_qca -nt $BUILD_qca/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_qca() {
  verify_binary lib/qca-qt5.framework/Versions/${VERSION_qca}/$LINK_qca
  verify_binary bin/qcatool-qt5
}

# function to append information to config file
function add_config_info_qca() {
  append_to_config_file "# qca-${VERSION_qca}: ${DESC_qca}"
  append_to_config_file "export VERSION_qca=${VERSION_qca}"
  append_to_config_file "export LINK_qca=${LINK_qca}"
}
