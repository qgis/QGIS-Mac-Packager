#!/bin/bash

DESC_laszip="Lossless LiDAR compression"

# version of your package
VERSION_laszip=3.4.3

LINK_liblaszip_api=liblaszip_api.8.dylib
LINK_liblaszip=liblaszip.8.dylib

# dependencies of this recipe
DEPS_laszip=()

# url of the package
URL_laszip=https://github.com/laszip/laszip/releases/download/${VERSION_laszip}/laszip-src-${VERSION_laszip}.tar.gz

# md5 of the package
MD5_laszip=e07be9ba6247889a4ba0bda8535c77e3

# default build path
BUILD_laszip=$BUILD_PATH/laszip/$(get_directory $URL_laszip)

# default recipe path
RECIPE_laszip=$RECIPES_PATH/laszip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_laszip() {
  cd $BUILD_laszip


}

function shouldbuild_laszip() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_liblaszip} -nt $BUILD_laszip/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_laszip() {
  verify_binary lib/${LINK_liblaszip_api}
  verify_binary lib/${LINK_liblaszip}
}

# function to append information to config file
function add_config_info_laszip() {
  append_to_config_file "# laszip-${VERSION_laszip}: ${DESC_laszip}"
  append_to_config_file "export VERSION_laszip=${VERSION_laszip}"
  append_to_config_file "export LINK_liblaszip_api=${LINK_liblaszip_api}"
  append_to_config_file "export LINK_liblaszip=${LINK_liblaszip}"
}