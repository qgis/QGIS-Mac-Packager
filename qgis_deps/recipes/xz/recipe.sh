#!/bin/bash

DESC_xz="General-purpose data compression with high compression ratio"

# version of your package
VERSION_xz=5.2.5

LINK_liblzma=liblzma.5.dylib

# dependencies of this recipe
DEPS_xz=(gettext)

# url of the package
URL_xz=https://downloads.sourceforge.net/project/lzmautils/xz-${VERSION_xz}.tar.xz

# md5 of the package
MD5_xz=aa1621ec7013a19abab52a8aff04fe5b

# default build path
BUILD_xz=${DEPS_BUILD_PATH}/xz/$(get_directory $URL_xz)

# default recipe path
RECIPE_xz=$RECIPES_PATH/xz

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xz() {
  cd $BUILD_xz
    patch_configure_file configure
  try rsync  -a $BUILD_xz/ ${DEPS_BUILD_PATH}/xz/build-${ARCH}

}

function shouldbuild_xz() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_liblzma -nt $BUILD_xz/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_xz() {
  verify_binary lib/$LINK_liblzma

  verify_binary bin/lzmainfo
  verify_binary bin/xzdec
}

# function to append information to config file
function add_config_info_xz() {
  append_to_config_file "# xz-${VERSION_xz}: ${DESC_xz}"
  append_to_config_file "export VERSION_xz=${VERSION_xz}"
  append_to_config_file "export LINK_liblzma=${LINK_liblzma}"
}