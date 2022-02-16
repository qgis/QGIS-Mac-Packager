#!/bin/bash

DESC_gettext="gettext"

# version of your package
VERSION_gettext=0.21
LINK_libintl=libintl.8.dylib

# dependencies of this recipe
DEPS_gettext=(libcurl libxml2 libunistring)

# url of the package
URL_gettext=https://ftp.gnu.org/pub/gnu/gettext/gettext-$VERSION_gettext.tar.gz

# md5 of the package
MD5_gettext=28b1cd4c94a74428723ed966c38cf479

# default build path
BUILD_gettext=$BUILD_PATH/gettext/$(get_directory $URL_gettext)

# default recipe path
RECIPE_gettext=$RECIPES_PATH/gettext

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gettext() {
  cd $BUILD_gettext
    patch_configure_file configure
  try rsync  -a $BUILD_gettext/ ${BUILD_PATH}/gettext/build-${ARCH}

}

function shouldbuild_gettext() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/bin/ggettextize -nt $BUILD_gettext/.patched ]; then
    DO_BUILD=0
  fi
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
