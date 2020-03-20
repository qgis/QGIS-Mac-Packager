#!/bin/bash

# version of your package
VERSION_libtasn1=4.16.0

LINK_libtasn1_version=6

# dependencies of this recipe
DEPS_libtasn1=()

# url of the package
URL_libtasn1=https://ftp.gnu.org/gnu/libtasn1/libtasn1-${VERSION_libtasn1}.tar.gz

# md5 of the package
MD5_libtasn1=531208de3729d42e2af0a32890f08736

# default build path
BUILD_libtasn1=$BUILD_PATH/libtasn1/$(get_directory $URL_libtasn1)

# default recipe path
RECIPE_libtasn1=$RECIPES_PATH/libtasn1

patch_tasn1_linker_links () {
  install_name_tool -id "@rpath/libtasn1.dylib" ${STAGE_PATH}/lib/libtasn1.dylib

  if [ ! -f "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib does not exist... maybe you updated the libtasn1 version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" "@rpath/libtasn1.${LINK_libtasn1_version}.dylib" ${STAGE_PATH}/bin/asn1Coding
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/asn1Coding

  install_name_tool -change "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" "@rpath/libtasn1.${LINK_libtasn1_version}.dylib" ${STAGE_PATH}/bin/asn1Decoding
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/asn1Decoding

  install_name_tool -change "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" "@rpath/libtasn1.${LINK_libtasn1_version}.dylib" ${STAGE_PATH}/bin/asn1Parser
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/asn1Parser
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtasn1() {
  cd $BUILD_libtasn1

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_libtasn1() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libtasn1.dylib -nt $BUILD_libtasn1/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtasn1() {
  try rsync -a $BUILD_libtasn1/ $BUILD_PATH/libtasn1/build-$ARCH/
  try cd $BUILD_PATH/libtasn1/build-$ARCH
  push_env

  export CFLAGS="$CFLAGS -O2 -DPIC"
  patch_configure_file configure

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  patch_tasn1_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_libtasn1() {
  verify_lib "libtasn1.dylib"
}
