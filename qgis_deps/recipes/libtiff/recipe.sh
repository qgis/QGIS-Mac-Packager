#!/bin/bash

DESC_libtiff="TIFF library and utilities"

# version of your package
VERSION_libtiff=4.3.0

LINK_libtiff=libtiff.5.dylib
LINK_libtiffxx=libtiffxx.5.dylib

# dependencies of this recipe
DEPS_libtiff=(xz zstd webp jpeg lerc zlib)

# url of the package
URL_libtiff=http://download.osgeo.org/libtiff/tiff-${VERSION_libtiff}.tar.gz

# md5 of the package
MD5_libtiff=0a2e4744d1426a8fc8211c0cdbc3a1b3

# default build path
BUILD_libtiff=$BUILD_PATH/libtiff/$(get_directory $URL_libtiff)

# default recipe path
RECIPE_libtiff=$RECIPES_PATH/libtiff


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtiff() {
  cd $BUILD_libtiff

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

# function called before build_libtiff
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libtiff() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/$LINK_libtiff" -nt $BUILD_libtiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtiff() {
  try mkdir -p $BUILD_PATH/libtiff/build-$ARCH
  try cd $BUILD_PATH/libtiff/build-$ARCH

  push_env

  try $CMAKE \
   -DWEBP_SUPPORT=BOOL:ON \
   -DLZMA_SUPPORT=BOOL:ON \
   -DZSTD_SUPPORT=BOOL:ON \
   -DLERC_SUPPORT=BOOL:ON \
   -DJPEG_SUPPORT=BOOL:ON \
   -DZIP_SUPPORT=BOOL:ON \
  $BUILD_libtiff .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiff

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiffxx
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx

  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/bin/tiffsplit

  pop_env
}

# function called after all the compile have been done
function postbuild_libtiff() {
  verify_binary lib/$LINK_libtiff
  verify_binary lib/${LINK_libtiffxx}
  verify_binary bin/tiffsplit
}

# function to append information to config file
function add_config_info_libtiff() {
  append_to_config_file "# libtiff-${VERSION_libtiff}: ${DESC_libtiff}"
  append_to_config_file "export VERSION_libtiff=${VERSION_libtiff}"
  append_to_config_file "export LINK_libtiff=${LINK_libtiff}"
  append_to_config_file "export LINK_libtiffxx=${LINK_libtiffxx}"
}