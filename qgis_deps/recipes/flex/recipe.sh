#!/bin/bash

DESC_flex="Fast Lexical Analyzer, generates Scanners (tokenizers)"

# version of your package
VERSION_flex=2.6.4
LINK_flex_version=2

# dependencies of this recipe
DEPS_flex=( bison )

# url of the package
URL_flex=https://github.com/westes/flex/releases/download/v${VERSION_flex}/flex-${VERSION_flex}.tar.gz

# md5 of the package
MD5_flex=2882e3179748cc9f9c23ec593d6adc8d

# default build path
BUILD_flex=$BUILD_PATH/flex/$(get_directory $URL_flex)

# default recipe path
RECIPE_flex=$RECIPES_PATH/flex

patch_flex_linker_links () {
  install_name_tool -id "@rpath/libfl.dylib" ${STAGE_PATH}/lib/libfl.dylib

  if [ ! -f "${STAGE_PATH}/lib/libfl.${LINK_flex_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libfl.${LINK_flex_version}.dylib does not exist... maybe you updated the flex version?"
  fi

  targets=(
    bin/flex
    bin/flex++
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libfl.${LINK_flex_version}.dylib" "@rpath/libfl.${LINK_flex_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_flex() {
  cd $BUILD_flex

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_flex() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libfl.dylib -nt $BUILD_flex/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_flex() {
  try rsync -a $BUILD_flex/ $BUILD_PATH/flex/build-$ARCH/
  try cd $BUILD_PATH/flex/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --enable-shared \
    --disable-dependency-tracking

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  patch_flex_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_flex() {
  verify_lib "libfl.dylib"
}
