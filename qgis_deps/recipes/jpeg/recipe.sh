#!/bin/bash

# version of your package
VERSION_jpeg=9d

LINK_jpeg_version=9

# dependencies of this recipe
DEPS_jpeg=()

# url of the package
URL_jpeg=https://www.ijg.org/files/jpegsrc.v${VERSION_jpeg}.tar.gz

# md5 of the package
MD5_jpeg=693a4e10906e66467ca21f045547fe15

# default build path
BUILD_jpeg=$BUILD_PATH/jpeg/$(get_directory $URL_jpeg)

# default recipe path
RECIPE_jpeg=$RECIPES_PATH/jpeg

patch_jpeg_linker_links () {
  install_name_tool -id "@rpath/libjpeg.dylib" ${STAGE_PATH}/lib/libjpeg.dylib

  if [ ! -f "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib does not exist... maybe you updated the jpeg version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/bin/cjpeg
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/cjpeg

  install_name_tool -change "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/bin/djpeg
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/djpeg

  install_name_tool -change "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/bin/jpegtran
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/jpegtran

  # this one does not link, do we need to rpath ?
  install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/bin/wrjpgcom
  install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/bin/rdjpgcom
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_jpeg() {
  cd $BUILD_jpeg

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_jpeg() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libjpeg.dylib -nt $BUILD_jpeg/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_jpeg() {
  try rsync -a $BUILD_jpeg/ $BUILD_PATH/jpeg/build-$ARCH/
  try cd $BUILD_PATH/jpeg/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  patch_jpeg_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_jpeg() {
  verify_lib "libjpeg.dylib"
}
