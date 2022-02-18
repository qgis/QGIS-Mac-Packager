#!/bin/bash

DESC_freetype="Software library to render fonts"

# version of your package
VERSION_freetype=2.10.2
LINK_freetype=libfreetype.6.dylib

# dependencies of this recipe
DEPS_freetype=(png brotli bz2 zlib)

# url of the package
URL_freetype=https://download.savannah.gnu.org/releases/freetype/freetype-$VERSION_freetype.tar.gz

# md5 of the package
MD5_freetype=b1cb620e4c875cd4d1bfa04945400945

# default build path
BUILD_freetype=${DEPS_BUILD_PATH}/freetype/$(get_directory $URL_freetype)

# default recipe path
RECIPE_freetype=$RECIPES_PATH/freetype

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freetype() {
  cd $BUILD_freetype
    patch_configure_file configure
  try rsync  -a $BUILD_freetype/ ${DEPS_BUILD_PATH}/freetype/build-${ARCH}

}

function shouldbuild_freetype() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_freetype -nt $BUILD_freetype/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_freetype() {
  verify_binary lib/$LINK_freetype
}

# function to append information to config file
function add_config_info_freetype() {
  append_to_config_file "# freetype-${VERSION_freetype}: ${DESC_freetype}"
  append_to_config_file "export VERSION_freetype=${VERSION_freetype}"
  append_to_config_file "export LINK_freetype=${LINK_freetype}"
}
