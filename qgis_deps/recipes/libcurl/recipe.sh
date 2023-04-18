#!/bin/bash

DESC_libcurl="Get a file from an HTTP, HTTPS or FTP server"

# version of your package
VERSION_libcurl=8.0.1

LINK_libcurl=libcurl.4.dylib

# dependencies of this recipe
DEPS_libcurl=(libtool openssl zstd zlib libssh2)

# url of the package
URL_libcurl=https://curl.haxx.se/download/curl-$VERSION_libcurl.tar.bz2

# md5 of the package
MD5_libcurl=b2e694208b4891d7396d118712148ff3

# default build path
BUILD_libcurl=$BUILD_PATH/libcurl/$(get_directory $URL_libcurl)

# default recipe path
RECIPE_libcurl=$RECIPES_PATH/libcurl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libcurl() {
  cd $BUILD_libcurl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libcurl() {
  if [ ${STAGE_PATH}/lib/${LINK_libcurl} -nt $BUILD_libcurl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libcurl() {
  try rsync -a $BUILD_libcurl/ $BUILD_PATH/libcurl/build-$ARCH/
  try cd $BUILD_PATH/libcurl/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --with-ssl=${STAGE_PATH} \
    --without-ca-bundle \
    --without-ca-path \
    --with-ca-fallback \
    --with-secure-transport \
    --with-default-ssl-backend=openssl \
    --without-libpsl \
    --without-gssapi \
    --without-nghttp2 \
    --without-brotli \
    --without-librtmp \
    --with-libssh2 \
    --without-libidn2 \

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libcurl() {
  verify_binary lib/$LINK_libcurl
}

# function to append information to config file
function add_config_info_libcurl() {
  append_to_config_file "# libcurl-${VERSION_libcurl}: ${DESC_libcurl}"
  append_to_config_file "export VERSION_libcurl=${VERSION_libcurl}"
  append_to_config_file "export LINK_libcurl=${LINK_libcurl}"
}