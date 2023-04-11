#!/bin/bash

DESC_openssl="Cryptography and SSL/TLS Toolkit"

# version of your package
# NOTE openssl version must be compatible with QT version, for example
# for Qt 5.14 see https://wiki.qt.io/Qt_5.14.1_Known_Issues
VERSION_openssl=1.1.1t

# dependencies of this recipe
DEPS_openssl=(ca_certificates)

LINK_libssl_version=1.1
LINK_libssl=libssl.${LINK_libssl_version}.dylib
LINK_libcrypto=libcrypto.${LINK_libssl_version}.dylib

# url of the package
URL_openssl=https://www.openssl.org/source/openssl-${VERSION_openssl}.tar.gz

# md5 of the package
MD5_openssl=1cfee919e0eac6be62c88c5ae8bcd91e

# default build path
BUILD_openssl=$BUILD_PATH/openssl/$(get_directory $URL_openssl)

# default recipe path
RECIPE_openssl=$RECIPES_PATH/openssl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_openssl() {
  cd $BUILD_openssl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_openssl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libssl -nt $BUILD_openssl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_openssl() {
  try rsync -a $BUILD_openssl/ $BUILD_PATH/openssl/build-$ARCH/
  try cd $BUILD_PATH/openssl/build-$ARCH
  push_env

  # This could interfere with how we expect OpenSSL to build.
  unset OPENSSL_LOCAL_CONFIG_DIR

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  try perl ./Configure \
    --prefix=$STAGE_PATH \
    --openssldir=${STAGE_PATH}/etc/openssl \
    darwin64-`uname -m`-cc enable-ec_nistp_64_gcc_128 \
    no-ssl3 \
    no-ssl3-method \
    no-zlib \

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install
  try ln -s ${STAGE_PATH}/etc/cert.pem ${STAGE_PATH}/etc/openssl

  pop_env
}

# function called after all the compile have been done
function postbuild_openssl() {
  verify_binary lib/$LINK_libssl
  verify_binary lib/$LINK_libcrypto
  verify_binary lib/engines-${LINK_libssl_version}/padlock.dylib
  verify_binary lib/engines-${LINK_libssl_version}/capi.dylib
  verify_binary bin/openssl
}

# function to append information to config file
function add_config_info_openssl() {
  append_to_config_file "# openssl-${VERSION_openssl}: ${DESC_openssl}"
  append_to_config_file "export VERSION_openssl=${VERSION_openssl}"
  append_to_config_file "export LINK_libssl=${LINK_libssl}"
  append_to_config_file "export LINK_libcrypto=${LINK_libcrypto}"

}