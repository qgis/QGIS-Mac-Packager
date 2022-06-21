#!/bin/bash

DESC_libtool="Library to extract data from Excel .xls files"

LINK_libltdl=libltdl.7.dylib

DEPS_libtool=()



# default build path
BUILD_libtool=${DEPS_BUILD_PATH}/libtool/$(get_directory $URL_libtool)

# default recipe path
RECIPE_libtool=$RECIPES_PATH/libtool

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtool() {
  cd $BUILD_libtool

  patch_configure_file configure
  try rsync -a $BUILD_libtool/ ${DEPS_BUILD_PATH}/libtool/build-$ARCH/
}

# function called after all the compile have been done
function postbuild_libtool() {
  verify_binary lib/$LINK_libltdl
}

# function to append information to config file
function add_config_info_libtool() {
  append_to_config_file "# libtool-${VERSION_libtool}: ${DESC_libtool}"
  append_to_config_file "export VERSION_libtool=${VERSION_libtool}"
  append_to_config_file "export LINK_libltdl=${LINK_libltdl}"
}
