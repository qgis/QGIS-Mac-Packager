#!/bin/bash

DESC_libssh2="SSH protocol"

# version of your package
VERSION_libssh2=1.9.0

LINK_libssh2=libssh2.1.dylib

# dependencies of this recipe
DEPS_libssh2=(openssl zlib)


# url of the package
URL_libssh2=https://libssh2.org/download/libssh2-$VERSION_libssh2.tar.gz

# md5 of the package
MD5_libssh2=1beefafe8963982adc84b408b2959927

# default build path
BUILD_libssh2=$BUILD_PATH/libssh2/$(get_directory $URL_libssh2)

# default recipe path
RECIPE_libssh2=$RECIPES_PATH/libssh2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libssh2() {
  cd $BUILD_libssh2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libssh2() {
  if [ ${STAGE_PATH}/lib/${LINK_libssh2} -nt $BUILD_libssh2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libssh2() {
  try rsync -a $BUILD_libssh2/ $BUILD_PATH/libssh2/build-$ARCH/
  try cd $BUILD_PATH/libssh2/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-debug \
      --disable-dependency-tracking \
      --disable-silent-rules \
      --disable-examples-build \
      --with-openssl \
      --with-libz \
      --with-libssl-prefix=${STAGE_PATH}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libssh2() {
  verify_binary lib/$LINK_libssh2
}

# function to append information to config file
function add_config_info_libssh2() {
  append_to_config_file "# libssh2-${VERSION_libssh2}: ${DESC_libssh2}"
  append_to_config_file "export VERSION_libssh2=${VERSION_libssh2}"
  append_to_config_file "export LINK_libssh2=${LINK_libssh2}"
}