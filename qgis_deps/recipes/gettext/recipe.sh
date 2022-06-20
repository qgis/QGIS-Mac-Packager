#!/bin/bash

DESC_gettext="gettext"

LINK_libintl=libintl.8.dylib

DEPS_gettext=(libcurl libxml2 libunistring)


# md5 of the package

# default build path
BUILD_gettext=${DEPS_BUILD_PATH}/gettext/$(get_directory $URL_gettext)

# default recipe path
RECIPE_gettext=$RECIPES_PATH/gettext

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gettext() {
  cd $BUILD_gettext
    patch_configure_file configure
  try rsync  -a $BUILD_gettext/ ${DEPS_BUILD_PATH}/gettext/build-${ARCH}

}


# function called after all the compile have been done
function postbuild_gettext() {
  verify_binary lib/$LINK_libintl
  verify_binary lib/libgettextlib.dylib
}

# function to append information to config file
function add_config_info_gettext() {
  append_to_config_file "# gettext-${VERSION_gettext}: ${DESC_gettext}"
  append_to_config_file "export VERSION_gettext=${VERSION_gettext}"
  append_to_config_file "export LINK_libintl=${LINK_libintl}"
}
