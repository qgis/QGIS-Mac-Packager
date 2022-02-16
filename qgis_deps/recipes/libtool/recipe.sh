#!/bin/bash

DESC_libtool="Library to extract data from Excel .xls files"

# version of your package
VERSION_libtool=2.4.6
LINK_libltdl=libltdl.7.dylib

# dependencies of this recipe
DEPS_libtool=()

# url of the package
URL_libtool=https://ftp.gnu.org/gnu/libtool/libtool-${VERSION_libtool}.tar.xz

# md5 of the package
MD5_libtool=1bfb9b923f2c1339b4d2ce1807064aa5

# default build path
BUILD_libtool=$BUILD_PATH/libtool/$(get_directory $URL_libtool)

# default recipe path
RECIPE_libtool=$RECIPES_PATH/libtool

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtool() {
  cd $BUILD_libtool

  patch_configure_file configure
  try rsync -a $BUILD_libtool/ $BUILD_PATH/libtool/build-$ARCH/
}

function shouldbuild_libtool() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libltdl -nt $BUILD_libtool/.patched ]; then
    DO_BUILD=0
  fi
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
