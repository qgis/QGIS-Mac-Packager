#!/bin/bash

DESC_libunistring="C string library for manipulating Unicode strings"

# version of your package
VERSION_libunistring=0.9.10

LINK_libunistring=libunistring.2.dylib

# dependencies of this recipe
DEPS_libunistring=()

# url of the package
URL_libunistring=https://ftp.gnu.org/gnu/libunistring/libunistring-$VERSION_libunistring.tar.xz

# md5 of the package
MD5_libunistring=db08bb384e81968957f997ec9808926e

# default build path
BUILD_libunistring=$BUILD_PATH/libunistring/$(get_directory $URL_libunistring)

# default recipe path
RECIPE_libunistring=$RECIPES_PATH/libunistring

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libunistring() {
  cd $BUILD_libunistring
  try rsync -a $BUILD_libunistring/ $BUILD_PATH/libunistring/build-$ARCH/
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