#!/bin/bash

DESC_pdal="Point data abstraction library"

# version of your package
VERSION_pdal=2.2.0

LINK_libpdalcpp=libpdalcpp.12.dylib
LINK_libpdal_plugin_kernel_fauxplugin=libpdal_plugin_kernel_fauxplugin.12.dylib
LINK_libpdal_util=libpdal_util.12.dylib

# dependencies of this recipe
DEPS_pdal=(
  gdal
  libgeotiff
  laszip
  libxml2
  zstd
  xz
  hdf5
  zlib
  libcurl
)

# url of the package
URL_pdal=https://github.com/PDAL/PDAL/releases/download/${VERSION_pdal}/PDAL-${VERSION_pdal}-src.tar.gz

# md5 of the package
MD5_pdal=52d84c5b64b7cd30770a225e3d13fce3

# default build path
BUILD_pdal=$BUILD_PATH/pdal/$(get_directory $URL_pdal)

# default recipe path
RECIPE_pdal=$RECIPES_PATH/pdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_pdal() {
  cd $BUILD_pdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_pdal() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libpdal_c} -nt $BUILD_pdal/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_pdal() {
  try mkdir -p $BUILD_PATH/pdal/build-$ARCH
  try cd $BUILD_PATH/pdal/build-$ARCH
  push_env

  try ${CMAKE} \
    -DWITH_LASZIP=TRUE \
    -DBUILD_PLUGIN_GREYHOUND=OFF \
    -DBUILD_PLUGIN_ICEBRIDGE=OFF \
    -DBUILD_PLUGIN_PCL=OFF \
    -DBUILD_PLUGIN_HDF=ON \
    -DBUILD_PLUGIN_PGPOINTCLOUD=OFF \
    -DBUILD_PLUGIN_PYTHON=OFF \
    -DBUILD_PLUGIN_SQLITE=OFF \
    -DWITH_TESTS=OFF \
    $BUILD_pdal
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdalcpp
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdalcpp

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util

  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdalcpp $STAGE_PATH/bin/pdal
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/bin/pdal

  pop_env
}

# function called after all the compile have been done
function postbuild_pdal() {
  verify_binary lib/${LINK_libpdalcpp}
  verify_binary lib/${LINK_libpdal_plugin_kernel_fauxplugin}
  verify_binary lib/${LINK_libpdal_util}
  verify_binary bin/pdal
}

# function to append information to config file
function add_config_info_pdal() {
  append_to_config_file "# pdal-${VERSION_pdal}: ${DESC_pdal}"
  append_to_config_file "export VERSION_pdal=${VERSION_pdal}"
  append_to_config_file "export LINK_libpdalcpp=${LINK_libpdalcpp}"
  append_to_config_file "export LINK_libpdal_plugin_kernel_fauxplugin=${LINK_libpdal_plugin_kernel_fauxplugin}"
  append_to_config_file "export LINK_libpdal_util=${LINK_libpdal_util}"
}
