#!/bin/bash

DESC_pcre2="Perl compatible regular expressions library"

# version of your package
VERSION_pcre2=10.39
LINK_pcre2=libpcre2.2.dylib

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

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_pcre2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_pcre2 -nt $BUILD_pcre2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_pcre2() {
  try rsync -a $BUILD_pcre2/ $BUILD_PATH/pcre2/build-$ARCH/
  try cd $BUILD_PATH/pcre2/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-dependency-tracking \
      --enable-utf8 \
      --enable-pcre8 \
      --enable-pcre16 \
      --enable-pcre32 \
      --enable-unicode-properties \
      --enable-pcregrep-libz \
      --enable-pcregrep-libbz2

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_pcre2() {
  verify_binary lib/$LINK_pcre
}

# function to append information to config file
function add_config_info_pcre2() {
  append_to_config_file "# pcre-${VERSION_pcre}: ${DESC_pcre}"
  append_to_config_file "export VERSION_pcre=${VERSION_pcre}"
  append_to_config_file "export LINK_pcre=${LINK_pcre}"
}
