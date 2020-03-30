#!/bin/bash

DESC_libxslt="C XSLT library for GNOME"

# version of your package
VERSION_libxslt=1.1.34
LINK_libxslt_version=1
LINK_libexslt_version=0

# dependencies of this recipe
DEPS_libxslt=(libxml2)

# url of the package
URL_libxslt=http://xmlsoft.org/sources/libxslt-${VERSION_libxslt}.tar.gz

# md5 of the package
MD5_libxslt=db8765c8d076f1b6caafd9f2542a304a

# default build path
BUILD_libxslt=$BUILD_PATH/libxslt/$(get_directory $URL_libxslt)

# default recipe path
RECIPE_libxslt=$RECIPES_PATH/libxslt

patch_libxslt_linker_links () {
  install_name_tool -id "@rpath/libxslt.dylib" ${STAGE_PATH}/lib/libxslt.dylib
  install_name_tool -id "@rpath/libexslt.dylib" ${STAGE_PATH}/lib/libexslt.dylib

  if [ ! -f "${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib does not exist... maybe you updated the libxslt version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libexslt.${LINK_libexslt_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libexslt.${LINK_libexslt_version}.dylib does not exist... maybe you updated the libxslt version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib" "@rpath/libxslt.${LINK_libxslt_version}.dylib" ${STAGE_PATH}/lib/libexslt.dylib

  install_name_tool -change "${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib" "@rpath/libxslt.${LINK_libxslt_version}.dylib" ${STAGE_PATH}/bin/xsltproc
  install_name_tool -change "${STAGE_PATH}/lib/libexslt.${LINK_libexslt_version}.dylib" "@rpath/libexslt.${LINK_libexslt_version}.dylib" ${STAGE_PATH}/bin/xsltproc
  install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/bin/xsltproc
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libxslt() {
  cd $BUILD_libxslt

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libxslt() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libxslt.dylib -nt $BUILD_libxslt/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libxslt() {
  try rsync -a $BUILD_libxslt/ $BUILD_PATH/libxslt/build-$ARCH/
  try cd $BUILD_PATH/libxslt/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-silent-rules \
    --disable-dependency-tracking \
    --without-python \
    --with-libxml-prefix=$STAGE_PATH

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  patch_libxslt_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_libxslt() {
  verify_lib "libxslt.dylib"
  verify_lib "libexslt.dylib"
}
