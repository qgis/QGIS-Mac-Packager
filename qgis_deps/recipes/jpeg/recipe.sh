#!/bin/bash

DESC_jpeg="Image manipulation library"

# version of your package
VERSION_jpeg=9e

LINK_jpeg=libjpeg.9.dylib

# dependencies of this recipe
DEPS_jpeg=()

# url of the package
URL_jpeg=https://www.ijg.org/files/jpegsrc.v${VERSION_jpeg}.tar.gz

# md5 of the package
MD5_jpeg=2489f1597b046425f5fcd3cf2df7d85f

# default build path
BUILD_jpeg=$BUILD_PATH/jpeg/$(get_directory $URL_jpeg)

# default recipe path
RECIPE_jpeg=$RECIPES_PATH/jpeg

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_jpeg() {
  cd $BUILD_jpeg
    patch_configure_file configure
  try rsync  -a $BUILD_jpeg/ ${BUILD_PATH}/jpeg/build-${ARCH}

}

function shouldbuild_jpeg() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_jpeg -nt $BUILD_jpeg/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_jpeg() {
  verify_binary lib/$LINK_jpeg
}

# function to append information to config file
function add_config_info_jpeg() {
  append_to_config_file "# jpeg-${VERSION_jpeg}: ${DESC_jpeg}"
  append_to_config_file "export VERSION_jpeg=${VERSION_jpeg}"
  append_to_config_file "export LINK_jpeg=${LINK_jpeg}"
}