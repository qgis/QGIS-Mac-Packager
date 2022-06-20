#!/bin/bash

DESC_expat="XML 1.0 parser"

LINK_expat=libexpat.1.dylib

DEPS_expat=()


# md5 of the package

# default build path
BUILD_expat=${DEPS_BUILD_PATH}/expat/$(get_directory $URL_expat)

# default recipe path
RECIPE_expat=$RECIPES_PATH/expat

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_expat() {
  cd $BUILD_expat
    patch_configure_file configure
  try rsync  -a $BUILD_expat/ ${DEPS_BUILD_PATH}/expat/build-${ARCH}

}


# function called after all the compile have been done
function postbuild_expat() {
  verify_binary lib/$LINK_expat
}

# function to append information to config file
function add_config_info_expat() {
  append_to_config_file "# expat-${VERSION_expat}: ${DESC_expat}"
  append_to_config_file "export VERSION_expat=${VERSION_expat}"
  append_to_config_file "export LINK_expat=${LINK_expat}"
}
