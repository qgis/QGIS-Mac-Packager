#!/bin/bash

DESC_libunistring="C string library for manipulating Unicode strings"


LINK_libunistring=libunistring.2.dylib

DEPS_libunistring=()


# md5 of the package

# default build path
BUILD_libunistring=${DEPS_BUILD_PATH}/libunistring/$(get_directory $URL_libunistring)

# default recipe path
RECIPE_libunistring=$RECIPES_PATH/libunistring

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libunistring() {
  cd $BUILD_libunistring
  patch_configure_file configure
  try rsync -a $BUILD_libunistring/ ${DEPS_BUILD_PATH}/libunistring/build-$ARCH/
}

function shouldbuild_libunistring() {
  if [ ${STAGE_PATH}/lib/${LINK_libunistring} -nt $BUILD_libunistring/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libunistring() {
  verify_binary lib/$LINK_libunistring
}

# function to append information to config file
function add_config_info_libunistring() {
  append_to_config_file "# libunistring-${VERSION_libunistring}: ${DESC_libunistring}"
  append_to_config_file "export VERSION_libunistring=${VERSION_libunistring}"
  append_to_config_file "export LINK_libunistring=${LINK_libunistring}"
}