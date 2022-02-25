#!/bin/bash

DESC_libxml2="GNOME XML library"

# version of your package
VERSION_libxml2=2.9.10
LINK_libxml2=libxml2.2.dylib

# dependencies of this recipe
DEPS_libxml2=()

# url of the package
URL_libxml2=http://xmlsoft.org/sources/libxml2-${VERSION_libxml2}.tar.gz

# md5 of the package
MD5_libxml2=10942a1dc23137a8aa07f0639cbfece5

# default build path
BUILD_libxml2=${DEPS_BUILD_PATH}/libxml2/$(get_directory $URL_libxml2)

# default recipe path
RECIPE_libxml2=$RECIPES_PATH/libxml2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libxml2() {
  cd $BUILD_libxml2
    patch_configure_file configure
  try rsync  -a $BUILD_libxml2/ ${DEPS_BUILD_PATH}/libxml2/build-${ARCH}

}

function shouldbuild_libxml2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libxml2 -nt $BUILD_libxml2/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libxml2() {
  verify_binary lib/$LINK_libxml2
}

# function to append information to config file
function add_config_info_libxml2() {
  append_to_config_file "# libxml2-${VERSION_libxml2}: ${DESC_libxml2}"
  append_to_config_file "export VERSION_libxml2=${VERSION_libxml2}"
  append_to_config_file "export LINK_libxml2=${LINK_libxml2}"
}