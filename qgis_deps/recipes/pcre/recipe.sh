#!/bin/bash

DESC_pcre="Perl compatible regular expressions library"

# version of your package
VERSION_pcre=8.44
LINK_pcre=libpcre.1.dylib

# dependencies of this recipe
DEPS_pcre=(
 bz2
 zlib
)

# url of the package
URL_pcre=https://ftp.exim.org/pub/pcre/pcre-$VERSION_pcre.tar.bz2

# md5 of the package
MD5_pcre=cf7326204cc46c755b5b2608033d9d24

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
function postbuild_pcre() {
  verify_binary lib/$LINK_pcre
}

# function to append information to config file
function add_config_info_pcre() {
  append_to_config_file "# pcre-${VERSION_pcre}: ${DESC_pcre}"
  append_to_config_file "export VERSION_pcre=${VERSION_pcre}"
  append_to_config_file "export LINK_pcre=${LINK_pcre}"
}
