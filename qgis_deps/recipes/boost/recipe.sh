#!/bin/bash

DESC_boost="Collection of portable C++ source libraries"

# version of your package
# version required by MySQL
VERSION_boost=1.73.0

# dependencies of this recipe
DEPS_boost=(zlib python libicu)

# url of the package
URL_boost=https://github.com/boostorg/boost/archive/refs/tags/boost-${VERSION_boost}.tar.gz

# from github it does not contain submodules in the build subdir
# URL_boost=https://github.com/boostorg/boost/archive/boost-${VERSION_boost}.tar.gz

# md5 of the package
MD5_boost=db0112a3a37a3742326471d20f1a186a

# default build path
BUILD_boost=$BUILD_PATH/boost/$(get_directory $URL_boost)

# default recipe path
RECIPE_boost=$RECIPES_PATH/boost

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_boost() {
  cd $BUILD_boost
  try rsync -a $BUILD_boost/ ${BUILD_PATH}/boost/build-${ARCH}


}

function shouldbuild_boost() {
  # If lib is newer than the sourcecode skip build
  pyver=${VERSION_major_python//./}
  if [ ${STAGE_PATH}/lib/libboost_python${pyver}.dylib -nt $BUILD_boost/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_boost() {
  verify_binary lib/libboost_python${VERSION_major_python//./}.dylib
}

# function to append information to config file
function add_config_info_boost() {
  append_to_config_file "# boost-${VERSION_boost}: ${DESC_boost}"
  append_to_config_file "export VERSION_boost=${VERSION_boost}"
}
