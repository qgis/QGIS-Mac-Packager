#!/bin/bash

DESC_libzip="C library for reading, creating, and modifying zip archives"


LINK_libzip=libzip.5.dylib

DEPS_libzip=( zlib xz openssl )


# md5 of the package

# default build path
BUILD_libzip=${DEPS_BUILD_PATH}/libzip/$(get_directory $URL_libzip)

# default recipe path
RECIPE_libzip=$RECIPES_PATH/libzip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libzip() {
  cd $BUILD_libzip


}

function shouldbuild_libzip() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libzip} -nt $BUILD_libzip/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libzip() {
  verify_binary lib/$LINK_libzip
  verify_binary bin/ziptool
}

# function to append information to config file
function add_config_info_libzip() {
  append_to_config_file "# libzip-${VERSION_libzip}: ${DESC_libzip}"
  append_to_config_file "export VERSION_libzip=${VERSION_libzip}"
  append_to_config_file "export LINK_libzip=${LINK_libzip}"
}