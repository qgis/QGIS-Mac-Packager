#!/bin/bash

# version of your package
VERSION_xz=5.2.4

LINK_liblzma_version=5

# dependencies of this recipe
DEPS_xz=()

# url of the package
URL_xz=https://downloads.sourceforge.net/project/lzmautils/xz-${VERSION_xz}.tar.gz

# md5 of the package
MD5_xz=5ace3264bdd00c65eeec2891346f65e6

# default build path
BUILD_xz=$BUILD_PATH/xz/$(get_directory $URL_xz)

# default recipe path
RECIPE_xz=$RECIPES_PATH/xz

patch_xz_linker_links () {
  install_name_tool -id "@rpath/liblzma.dylib" ${STAGE_PATH}/lib/liblzma.dylib

  if [ ! -f "${STAGE_PATH}/lib/liblzma.${LINK_liblzma_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/liblzma.${LINK_liblzma_version}.dylib does not exist... maybe you updated the xz version?"
  fi

  targets=(
    bin/lzmainfo
    bin/xzdec
    bin/xz
    bin/lzmadec
    bin/zstd
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/liblzma.${LINK_liblzma_version}.dylib" "@rpath/liblzma.${LINK_liblzma_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xz() {
  cd $BUILD_xz

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_xz() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/liblzma.dylib -nt $BUILD_xz/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_xz() {
  try rsync -a $BUILD_xz/ $BUILD_PATH/xz/build-$ARCH/
  try cd $BUILD_PATH/xz/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  patch_xz_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_xz() {
  verify_lib "liblzma.dylib"

  verify_bin lzmainfo
  verify_bin xzdec
  verify_bin zstd
}
