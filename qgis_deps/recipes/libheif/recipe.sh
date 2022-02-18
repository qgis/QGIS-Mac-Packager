#!/bin/bash

DESC_libheif="GNOME XML library"

# version of your package
VERSION_libheif=1.12.0
LINK_libheif=libheif.1.dylib

# dependencies of this recipe
DEPS_libheif=(libde265 libaom)

# url of the package
URL_libheif=https://github.com/strukturag/libheif/releases/download/v${VERSION_libheif}/libheif-${VERSION_libheif}.tar.gz

# md5 of the package
MD5_libheif=f6dd5c4fe0efb8598eb63df71213d58b

# default build path
BUILD_libheif=$BUILD_PATH/libheif/$(get_directory $URL_libheif)

# default recipe path
RECIPE_libheif=$RECIPES_PATH/libheif

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libheif() {
  cd $BUILD_libheif
  try rsync  -a $BUILD_libheif/ ${BUILD_PATH}/libheif/build-${ARCH}
}

function shouldbuild_libheif() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libheif -nt $BUILD_libheif/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libheif() {
  verify_binary lib/$LINK_libheif
}

# function to append information to config file
function add_config_info_libheif() {
  append_to_config_file "# libheif-${VERSION_libheif}: ${DESC_libheif}"
  append_to_config_file "export VERSION_libheif=${VERSION_libheif}"
  append_to_config_file "export LINK_libheif=${LINK_libheif}"
}