#!/bin/bash

DESC_pcre2="Perl compatible regular expressions library"

# version of your package
VERSION_pcre2=10.39
LINK_pcre2=libpcre2-8.dylib

# dependencies of this recipe
DEPS_pcre2=(
 bz2
 zlib
)

# url of the package
URL_pcre2=https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${VERSION_pcre2}/pcre2-${VERSION_pcre2}.tar.bz2

# md5 of the package
MD5_pcre2=4a765b1419c2e7a01263c3260abca87a

# default build path
BUILD_pcre2=$BUILD_PATH/pcre2/$(get_directory $URL_pcre2)

# default recipe path
RECIPE_pcre2=$RECIPES_PATH/pcre2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_pcre2() {
  cd $BUILD_pcre2
    patch_configure_file configure
  try rsync  -a $BUILD_pcre2/ ${BUILD_PATH}/pcre2/build-${ARCH}

}

function shouldbuild_pcre2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_pcre2 -nt $BUILD_pcre2/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_pcre2() {
  verify_binary lib/$LINK_pcre2
}

# function to append information to config file
function add_config_info_pcre2() {
  append_to_config_file "# pcre2-${VERSION_pcre2}: ${DESC_pcre2}"
  append_to_config_file "export VERSION_pcre2=${VERSION_pcre2}"
  append_to_config_file "export LINK_pcre2=${LINK_pcre2}"
}
