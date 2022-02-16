#!/bin/bash

DESC_libcurl="Get a file from an HTTP, HTTPS or FTP server"

# version of your package
VERSION_libcurl=7.75.0

LINK_libcurl=libcurl.4.dylib

# dependencies of this recipe
DEPS_libcurl=(libtool openssl zstd zlib libssh2)

# url of the package
URL_libcurl=https://curl.haxx.se/download/curl-$VERSION_libcurl.tar.bz2

# md5 of the package
MD5_libcurl=29472feb977cea2992ef9082c153698d

# default build path
BUILD_libcurl=$BUILD_PATH/libcurl/$(get_directory $URL_libcurl)

# default recipe path
RECIPE_libcurl=$RECIPES_PATH/libcurl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libcurl() {
  cd $BUILD_libcurl
    patch_configure_file configure
  try rsync  -a $BUILD_libcurl/ ${BUILD_PATH}/libcurl/build-${ARCH}

}

function shouldbuild_libcurl() {
  if [ ${STAGE_PATH}/lib/${LINK_libcurl} -nt $BUILD_libcurl/.patched ]; then
    DO_BUILD=0
  fi
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