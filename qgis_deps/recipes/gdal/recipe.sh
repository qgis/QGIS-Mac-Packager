#!/bin/bash

DESC_gdal="Geospatial Data Abstraction Library"

# keep in SYNC with python_gdal receipt

source ${RECIPES_PATH}/netcdf/recipe.sh
source ${RECIPES_PATH}/xerces/recipe.sh

LINK_gdal=libgdal.dylib.${VERSION_gdal}

DEPS_gdal=(
  expat
  freexl
  geos
  hdf5
  jpeg
  lerc
  libcurl
  libgeotiff
  libkml
  libtiff
  libxml2
  netcdf
  pcre2
  png
  poppler
  postgres
  proj
  spatialite
  sqlite
  unixodbc
  xerces
  xz
  zstd
)



# default build path
BUILD_gdal=${DEPS_BUILD_PATH}/gdal/$(get_directory ${URL_gdal})

# default recipe path
RECIPE_gdal=${RECIPES_PATH}/gdal

# This directory is automatically picked by GDAL on load to search for drivers
GDAL_PLUGINS_DIR=${STAGE_PATH}/lib/gdalplugins

# 3rd Party
# This directory is NOT automatically picked by GDAL. Compile driver
# that required some external 3rdParty licensed SDK/library, so
# normally you are not able to load them from qgis-deps
GDAL_NOFOSS_PLUGINS_DIR=${STAGE_PATH}/3rdParty/gdalplugins

ECW_SDK_VER="ERDASEcwJpeg2000SDK5.5.0"
ECW_SDK="${QGIS_PRIVATE_SDKS_PATH}/${ECW_SDK_VER}/Desktop_Read-Only/"
LINK_gdal_ecw=gdal_ECW_JP2ECW.dylib

MRSID_SDK_VER="MrSID_DSDK-9.5.1.4427-darwin14.universal.clang60"
MRSID_SDK="${QGIS_PRIVATE_SDKS_PATH}/${MRSID_SDK_VER}"
LINK_gdal_mrsid_lidar=gdal_MG4Lidar.dylib
LINK_gdal_mrsid_raster=gdal_MrSID.dylib

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd ${BUILD_gdal}

  try rsync -a $BUILD_gdal/ ${DEPS_BUILD_PATH}/gdal/build-$ARCH/

  patch_configure_file configure
}

# function called after all the compile have been done
function postbuild_gdal() {
  verify_binary lib/${LINK_gdal}
  verify_binary bin/gdalmanage
  verify_binary bin/gdalinfo

  if [[ "${WITH_ECW}" == "true" ]]; then
    verify_binary ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_ecw}
  fi

  if [[ "${MRSID_SDK}" == "true" ]]; then
    verify_binary ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_mrsid_lidar}
    verify_binary ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_mrsid_raster}
  fi

  test_binary_output "./bin/ogrinfo --formats" OSM
  test_binary_output "./bin/ogrinfo --formats" MSSQLSpatial
}

# function to append information to config file
function add_config_info_gdal() {
  append_to_config_file "# gdal-${VERSION_gdal}: ${DESC_gdal}"
  if [[ "${WITH_ECW}" == "true" ]]; then
    append_to_config_file "# gdal with ECW driver (SDK not bundled in deps)"
    append_to_config_file "export LINK_gdal_ecw=${LINK_gdal_ecw}"
    append_to_config_file "export ECW_SDK_VER=${ECW_SDK_VER}"
  fi
  if [[ "${WITH_MRSID}" == "true" ]]; then
    append_to_config_file "# gdal with MRSID driver (SDK not bundled in deps)"
    append_to_config_file "export LINK_gdal_mrsid_raster=${LINK_gdal_mrsid_raster}"
    append_to_config_file "export LINK_gdal_mrsid_lidar=${LINK_gdal_mrsid_lidar}"
    append_to_config_file "export MRSID_SDK_VER=${MRSID_SDK_VER}"
  fi

  append_to_config_file "export VERSION_gdal=${VERSION_gdal}"
  append_to_config_file "export LINK_gdal=${LINK_gdal}"
}
