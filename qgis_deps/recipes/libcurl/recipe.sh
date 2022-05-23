#!/bin/bash

DESC_libcurl="Get a file from an HTTP, HTTPS or FTP server"


LINK_libcurl=libcurl.dylib

DEPS_libcurl=(libtool openssl zstd zlib libssh2)


# md5 of the package

# default build path
BUILD_libcurl=${DEPS_BUILD_PATH}/libcurl/$(get_directory $URL_libcurl)

# default recipe path
RECIPE_libcurl=$RECIPES_PATH/libcurl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libcurl() {
  cd $BUILD_libcurl
  try rsync  -a $BUILD_libcurl/ ${DEPS_BUILD_PATH}/libcurl/build-${ARCH}
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