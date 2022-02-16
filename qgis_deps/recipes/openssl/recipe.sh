#!/bin/bash

DESC_openssl="Cryptography and SSL/TLS Toolkit"

# version of your package
# NOTE openssl version must be compatible with QT version, for example
# for Qt 5.14 see https://wiki.qt.io/Qt_5.14.1_Known_Issues
VERSION_openssl=1.1.1i

# dependencies of this recipe
DEPS_openssl=()

LINK_libssl_version=1.1
LINK_libssl=libssl.${LINK_libssl_version}.dylib
LINK_libcrypto=libcrypto.${LINK_libssl_version}.dylib

# url of the package
URL_openssl=https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_${VERSION_openssl//./_}.tar.gz

# md5 of the package
MD5_openssl=882525c88bd6bec13bfdd70a656b0951

# default build path
BUILD_openssl=$BUILD_PATH/openssl/$(get_directory $URL_openssl)

# default recipe path
RECIPE_openssl=$RECIPES_PATH/openssl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_openssl() {
  cd $BUILD_openssl
    patch_configure_file configure
  try rsync  -a $BUILD_openssl/ ${BUILD_PATH}/openssl/build-${ARCH}

}

function shouldbuild_openssl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libssl -nt $BUILD_openssl/.patched ]; then
    DO_BUILD=0
  fi
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