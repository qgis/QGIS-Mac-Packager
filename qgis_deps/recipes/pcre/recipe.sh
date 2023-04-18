#!/bin/bash

DESC_pcre="Perl compatible regular expressions library"

# version of your package
VERSION_pcre=10.37
LINK_pcre=libpcre2-posix.3.dylib

# dependencies of this recipe
DEPS_pcre=(
 bz2
 zlib
)

# url of the package
URL_pcre=https://ftp.exim.org/pub/pcre/pcre2-$VERSION_pcre.tar.gz

# md5 of the package
MD5_pcre=a0b59d89828f62d2e1caac04f7c51e0b

# default build path
BUILD_pcre=$BUILD_PATH/pcre/$(get_directory $URL_pcre)

# default recipe path
RECIPE_pcre=$RECIPES_PATH/pcre

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_pcre() {
  cd $BUILD_pcre

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_pcre() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_pcre -nt $BUILD_pcre/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_pcre() {
  try rsync -a $BUILD_pcre/ $BUILD_PATH/pcre/build-$ARCH/
  try cd $BUILD_PATH/pcre/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-dependency-tracking \
      --enable-utf8 \
      --enable-pcre2-8 \
      --enable-pcre2-16 \
      --enable-pcre2-32 \
      --enable-unicode-properties \
      --enable-pcregrep-libz \
      --enable-pcregrep-libbz2

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_pcre() {
  verify_binary lib/$LINK_pcre
}

# function to append information to config file
function add_config_info_pcre() {
  append_to_config_file "# pcre-${VERSION_pcre}: ${DESC_pcre}"
  append_to_config_file "export VERSION_pcre=${VERSION_pcre}"
  append_to_config_file "export LINK_pcre=${LINK_pcre}"
}
