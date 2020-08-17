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
)

# url of the package
URL_gdal=https://github.com/OSGeo/gdal/releases/download/v${VERSION_gdal}/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=68349526344ee45accf2773a1a6e71f2

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

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
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --enable-driver-gpkg \
    --enable-driver-mbtiles \
    --enable-driver-gml \
    --enable-driver-mvt \
    --enable-driver-xlsx \
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

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
  verify_binary lib/$LINK_gdal
  verify_binary bin/gdalmanage
  verify_binary bin/gdalinfo
}

# function to append information to config file
function add_config_info_gdal() {
  append_to_config_file "# gdal-${VERSION_gdal}: ${DESC_gdal}"
  append_to_config_file "export VERSION_gdal=${VERSION_gdal}"
  append_to_config_file "export LINK_gdal=${LINK_gdal}"
}