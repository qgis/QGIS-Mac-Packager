#!/bin/bash

DESC_libtiff="TIFF library and utilities"

# version of your package
VERSION_libtiff=4.5.0

LINK_libtiff=libtiff.6.dylib
LINK_libtiffxx=libtiffxx.6.dylib

# dependencies of this recipe
DEPS_libtiff=(xz zstd webp jpeg lerc zlib)

# url of the package
URL_libtiff=http://download.osgeo.org/libtiff/tiff-${VERSION_libtiff}.tar.gz

# md5 of the package
MD5_libtiff=db9e220a1971acc64487f1d51a20dcaa

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

  try fix_install_name bin/fax2ps
  try fix_install_name bin/fax2tiff
  try fix_install_name bin/pal2rgb
  try fix_install_name bin/ppm2tiff
  try fix_install_name bin/raw2tiff
  try fix_install_name bin/tiff2bw
  try fix_install_name bin/tiff2pdf
  try fix_install_name bin/tiff2ps
  try fix_install_name bin/tiff2rgba
  try fix_install_name bin/tiffcmp
  try fix_install_name bin/tiffcp
  try fix_install_name bin/tiffcrop
  try fix_install_name bin/tiffdither
  try fix_install_name bin/tiffdump
  try fix_install_name bin/tiffgt
  try fix_install_name bin/tiffinfo
  try fix_install_name bin/tiffmedian
  try fix_install_name bin/tiffset

  pop_env
}

# function called after all the compile have been done
function postbuild_libtiff() {
  verify_binary lib/$LINK_libtiff
  verify_binary lib/${LINK_libtiffxx}
  verify_binary bin/tiffsplit
  verify_binary bin/fax2ps
  verify_binary bin/fax2tiff
  verify_binary bin/pal2rgb
  verify_binary bin/ppm2tiff
  verify_binary bin/raw2tiff
  verify_binary bin/tiff2bw
  verify_binary bin/tiff2pdf
  verify_binary bin/tiff2ps
  verify_binary bin/tiff2rgba
  verify_binary bin/tiffcmp
  verify_binary bin/tiffcp
  verify_binary bin/tiffcrop
  verify_binary bin/tiffdither
  verify_binary bin/tiffdump
  verify_binary bin/tiffgt
  verify_binary bin/tiffinfo
  verify_binary bin/tiffmedian
  verify_binary bin/tiffset
}

# function to append information to config file
function add_config_info_libtiff() {
  append_to_config_file "# libtiff-${VERSION_libtiff}: ${DESC_libtiff}"
  append_to_config_file "export VERSION_libtiff=${VERSION_libtiff}"
  append_to_config_file "export LINK_libtiff=${LINK_libtiff}"
  append_to_config_file "export LINK_libtiffxx=${LINK_libtiffxx}"
}