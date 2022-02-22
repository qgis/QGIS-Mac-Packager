#!/bin/bash

DESC_libssh2="SSH protocol"


LINK_libssh2=libssh2.1.dylib

DEPS_libssh2=(openssl zlib)



# md5 of the package

# default build path
BUILD_libssh2=${DEPS_BUILD_PATH}/libssh2/$(get_directory $URL_libssh2)

# default recipe path
RECIPE_libssh2=$RECIPES_PATH/libssh2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libssh2() {
  cd $BUILD_libssh2
    patch_configure_file configure
  try rsync  -a $BUILD_libssh2/ ${DEPS_BUILD_PATH}/libssh2/build-${ARCH}

}

function shouldbuild_libssh2() {
  if [ ${STAGE_PATH}/lib/${LINK_libssh2} -nt $BUILD_libssh2/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libssh2() {
  verify_binary lib/$LINK_libssh2
}

# function to append information to config file
function add_config_info_libssh2() {
  append_to_config_file "# libssh2-${VERSION_libssh2}: ${DESC_libssh2}"
  append_to_config_file "export VERSION_libssh2=${VERSION_libssh2}"
  append_to_config_file "export LINK_libssh2=${LINK_libssh2}"
}