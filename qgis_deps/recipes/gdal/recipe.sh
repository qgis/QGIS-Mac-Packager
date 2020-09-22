#!/bin/bash

DESC_gdal="Geospatial Data Abstraction Library"

# version of your package
# keep in SYNC with python_gdal receipt
VERSION_gdal=3.1.2

source $RECIPES_PATH/netcdf/recipe.sh
source $RECIPES_PATH/xerces/recipe.sh

LINK_libgdal_version=27
LINK_gdal=libgdal.$LINK_libgdal_version.dylib

# dependencies of this recipe
DEPS_gdal=(
  geos
  proj
  libgeotiff
  libxml2
  xerces
  xz
  zstd
  libtiff
  netcdf
  hdf5
  postgres
  jpeg
  png
  sqlite
  poppler
  expat
  freexl
  libkml
  pcre
  unixodbc
)

# url of the package
URL_gdal=https://github.com/OSGeo/gdal/releases/download/v${VERSION_gdal}/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=68349526344ee45accf2773a1a6e71f2

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

# This directory is automatically picked by GDAL on load to search for drivers
GDAL_PLUGINS_DIR=${STAGE_PATH}/lib/gdalplugins

# 3rd Party
# This directory is NOT automatically picked by GDAL. Compile driver
# that required some external 3rdParty licensed SDK/library, so
# normally you are not able to load them from qgis-deps
GDAL_NOFOSS_PLUGINS_DIR=${STAGE_PATH}/3rdParty/gdalplugins

ECW_SDK_VER="ERDASEcwJpeg2000SDK5.4.0"
ECW_SDK="$RECIPES_PATH/../../../external/$ECW_SDK_VER/Desktop_Read-Only/"
LINK_gdal_ecw=gdal_ECW_JP2ECW.dylib

MRSID_SDK_VER="MrSID_DSDK-9.5.1.4427-darwin14.universal.clang60"
MRSID_SDK="$RECIPES_PATH/../../../external/$MRSID_SDK_VER"
LINK_gdal_mrsid_lidar=gdal_MG4Lidar.dylib
LINK_gdal_mrsid_raster=gdal_MrSID.dylib

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_gdal -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
  # DO_BUILD=1
}

function build_ecw() {
  try cd $BUILD_PATH/gdal/build-$ARCH

  if [[ "$WITH_ECW" == "true" ]]; then
    info "building GDAL ECW driver to $GDAL_NOFOSS_PLUGINS_DIR"

    if [ ! -d "$ECW_SDK" ]; then
      echo "Missing ECW SDK in $ECW_SDK"
      exit 1
    fi

    SRC=$(find frmts/ecw -name *.cpp)

    try $CXX -std=c++11 \
      -Iport -Igcore -Ifrmts -Iogr -DFRMT_ecw -DECWSDK_VERSION=53 -Ifrmts/ecw -DDO_NOT_USE_DEBUG_BOOL \
      -I$ECW_SDK/include -I$ECW_SDK/include/NCSEcw/API \
      -I$ECW_SDK/include/NCSEcw/ECW -I$ECW_SDK/include/NCSEcw/JP2 \
      ${SRC} \
      -dynamiclib \
      -install_name $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_ecw} \
      -current_version ${LINK_libgdal_version} \
      -compatibility_version ${LINK_libgdal_version}.0 \
      -o $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_ecw} \
      -undefined dynamic_lookup \
      -L$ECW_SDK/lib -lNCSEcw
  fi
}

function build_mrsid() {
  try cd $BUILD_PATH/gdal/build-$ARCH

  if [[ "$WITH_MRSID" == "true" ]]; then
    if [ ! -d "$MRSID_SDK" ]; then
      echo "Missing MRSID SDK in $MRSID_SDK"
      exit 1
    fi

    # LIDAR
    info "building GDAL MrSID Lidar driver to $GDAL_NOFOSS_PLUGINS_DIR"
    SRC=$(find frmts/mrsid_lidar -name *.c*)
    try $CXX -std=c++11 \
       -Iport -Igcore -Ifrmts -Iogr -Ifrmts/mrsid_lidar \
      -I$MRSID_SDK/Lidar_DSDK/include \
      ${SRC} \
      -dynamiclib \
      -install_name $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_lidar} \
      -current_version ${LINK_libgdal_version} \
      -compatibility_version ${LINK_libgdal_version}.0 \
      -o $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_lidar} \
      -undefined dynamic_lookup \
      -L$MRSID_SDK/Lidar_DSDK/lib -llti_lidar_dsdk

    # RASTER
    info "building GDAL MRSID driver to $GDAL_NOFOSS_PLUGINS_DIR"
    SRC=$(find frmts/mrsid -name *.c*)
    try $CXX -std=c++11 \
      -DMRSID_J2K=1 \
      -Iport -Igcore -Ifrmts -Iogr -Ifrmts/mrsid -Ifrmts/gtiff/libgeotiff \
      -I$MRSID_SDK/Raster_DSDK/include \
      ${SRC} \
      -dynamiclib \
      -install_name $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_raster} \
      -current_version ${LINK_libgdal_version} \
      -compatibility_version ${LINK_libgdal_version}.0 \
      -o $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_raster} \
      -undefined dynamic_lookup \
      -L$MRSID_SDK/Raster_DSDK/lib -lltidsdk
  fi
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH
  push_env

  try mkdir -p $GDAL_NOFOSS_PLUGINS_DIR
  try mkdir -p $GDAL_PLUGINS_DIR

  # add unixodbc
  export CFLAGS="$CFLAGS -I$STAGE_PATH/unixodbc/include"
  export LDFLAGS="$LDFLAGS -L$STAGE_PATH/unixodbc/lib"
  export CXXFLAGS="${CFLAGS}"

  try ${CONFIGURE} \
    --with-ecw=no \
    --with-mrsid=no \
    --disable-debug \
    --enable-driver-gpkg \
    --enable-driver-mbtiles \
    --enable-driver-gml \
    --enable-driver-mvt \
    --enable-driver-xlsx \
    --enable-driver-mssqlspatial \
    --with-odbc=yes \
    --with-liblzma=$STAGE_PATH \
    --with-zstd=$STAGE_PATH \
    --with-libtiff=$STAGE_PATH \
    --with-geotiff=$STAGE_PATH \
    --with-jpeg=$STAGE_PATH \
    --with-hdf5=$STAGE_PATH \
    --with-netcdf=$STAGE_PATH \
    --with-png=$STAGE_PATH \
    --with-spatialite=$STAGE_PATH \
    --with-sqlite3=$STAGE_PATH \
    --with-freexl=$STAGE_PATH \
    --with-libkml=$STAGE_PATH \
    --with-xerces=$STAGE_PATH \
    --with-xerces-inc=$STAGE_PATH/include \
    --with-xerces-lib="-lxerces-c" \
    --with-expat=$STAGE_PATH \
    --with-expat-inc=$STAGE_PATH/include \
    --with-expat-lib="-lexpat" \
    --with-poppler=$STAGE_PATH

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  build_ecw
  build_mrsid

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
  verify_binary lib/$LINK_gdal
  verify_binary bin/gdalmanage
  verify_binary bin/gdalinfo

  if [[ "$WITH_ECW" == "true" ]]; then
    verify_binary $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_ecw}
  fi

  if [[ "$MRSID_SDK" == "true" ]]; then
    verify_binary $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_lidar}
    verify_binary $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_raster}
  fi

  test_binary_output "./bin/ogrinfo --formats" OSM
  test_binary_output "./bin/ogrinfo --formats" MSSQLSpatial
}

# function to append information to config file
function add_config_info_gdal() {
  append_to_config_file "# gdal-${VERSION_gdal}: ${DESC_gdal}"
  if [[ "$WITH_ECW" == "true" ]]; then
    append_to_config_file "# gdal with ECW driver (SDK not bundled in deps)"
    append_to_config_file "export LINK_gdal_ecw=${LINK_gdal_ecw}"
    append_to_config_file "export ECW_SDK_VER=${ECW_SDK_VER}"
  fi
  if [[ "$WITH_MRSID" == "true" ]]; then
    append_to_config_file "# gdal with MRSID driver (SDK not bundled in deps)"
    append_to_config_file "export LINK_gdal_mrsid_raster=${LINK_gdal_mrsid_raster}"
    append_to_config_file "export LINK_gdal_mrsid_lidar=${LINK_gdal_mrsid_lidar}"
    append_to_config_file "export MRSID_SDK_VER=${MRSID_SDK_VER}"
  fi

  append_to_config_file "export VERSION_gdal=${VERSION_gdal}"
  append_to_config_file "export LINK_gdal=${LINK_gdal}"
}
