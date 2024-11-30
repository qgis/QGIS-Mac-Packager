#!/bin/bash

DESC_gdal="Geospatial Data Abstraction Library"

# version of your package
# keep in SYNC with python_gdal receipt
VERSION_gdal=3.6.3

source $RECIPES_PATH/netcdf/recipe.sh
source $RECIPES_PATH/xerces/recipe.sh

LINK_libgdal_version=32
LINK_gdal=libgdal.$LINK_libgdal_version.dylib

# dependencies of this recipe
DEPS_gdal=(
  apache_arrow
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
  pcre
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

# url of the package
URL_gdal=https://github.com/OSGeo/gdal/releases/download/v${VERSION_gdal}/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=86bae8db7b8bde2bc77decf7fcd3dfd0

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

ECW_SDK_VER="ERDASEcwJpeg2000SDK5.5.0"
ECW_SDK="$RECIPES_PATH/../../../external/$ECW_SDK_VER/Desktop_Read-Only/"
LINK_gdal_ecw=gdal_ECW_JP2ECW.dylib

MRSID_SDK_VER="MrSID_DSDK-9.5.5.5244-darwin22.universal.clang140"
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

  # patch_configure_file configure

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_gdal -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
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
      -Iport -Igcore -Ifrmts -Iogr -DFRMT_ecw -DECWSDK_VERSION=55 -Ifrmts/ecw -DDO_NOT_USE_DEBUG_BOOL \
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

  # cmake
  try ${CMAKE} $BUILD_gdal \
    -DCMAKE_CXX_STANDARD=17 \
    -DGDAL_USE_ODBC=ON \
    -DODBC_INCLUDE_DIR=$STAGE_PATH/unixodbc/include \
    -DODBC_LIBRARY=$STAGE_PATH/unixodbc/lib/libodbc.dylib \
    -DODBC_ODBCINST_LIBRARY=$STAGE_PATH/unixodbc/lib/libodbcinst.dylib \
    -DCMAKE_INSTALL_PREFIX=$STAGE_PATH \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG" \
    -DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG" \
    -DGDAL_USE_ECW=OFF \
    -DGDAL_USE_MRSID=OFF \
    -DGDAL_USE_LERC=ON \
    -DLERC_INCLUDE_DIR=$STAGE_PATH/include \
    -DLERC_LIBRARY=$STAGE_PATH/lib/libLerc.dylib \
    -DZSTD_INCLUDE_DIR=$STAGE_PATH/include \
    -DZSTD_LIBRARY=$STAGE_PATH/lib/libzstd.dylib \
    -DOGR_ENABLE_DRIVER_GPKG=ON \
    -DOGR_ENABLE_DRIVER_MBTILES=ON \
    -DOGR_ENABLE_DRIVER_GML=ON \
    -DOGR_ENABLE_DRIVER_MVT=ON \
    -DOGR_ENABLE_DRIVER_XLSX=ON \
    -DOGR_ENABLE_DRIVER_MSSQLSPATIAL=ON \
    -DGDAL_USE_ODBC=ON \
    -DGDAL_USE_LIBLZMA=ON \
    -DLIBLZMA_INCLUDE_DIR=$STAGE_PATH/include \
    -DLIBLZMA_LIBRARY=$STAGE_PATH/lib/liblzma.dylib \
    -DGDAL_USE_TIFF=ON \
    -DTIFF_INCLUDE_DIR=$STAGE_PATH/include \
    -DTIFF_LIBRARY=$STAGE_PATH/lib/libtiff.dylib \
    -DGDAL_USE_GEOTIFF=ON \
    -DGEOTIFF_INCLUDE_DIR=$STAGE_PATH/include \
    -DGEOTIFF_LIBRARY_RELEASE=$STAGE_PATH/lib/libgeotiff.a \
    -DGDAL_USE_JPEG=ON \
    -DJPEG_INCLUDE_DIR=$STAGE_PATH/include \
    -DJPEG_LIBRARY_RELEASE=$STAGE_PATH/lib/libjpeg.dylib \
    -DGDAL_USE_HDF5=ON \
    -DHDF5_INCLUDE_DIR=$STAGE_PATH/include \
    -DHDF5_LIBRARY=$STAGE_PATH/lib/libhdf5.dylib \
    -DGDAL_USE_NETCDF=ON \
    -DNETCDF_INCLUDE_DIR=$STAGE_PATH/include \
    -DNETCDF_LIBRARY=$STAGE_PATH/lib/libnetcdf.dylib \
    -DGDAL_USE_PNG=ON \
    -DPNG_PNG_INCLUDE_DIR=$STAGE_PATH/include \
    -DPNG_LIBRARY_RELEASE=$STAGE_PATH/lib/libpng.dylib \
    -DGDAL_USE_SPATIALITE=ON \
    -DSPATIALITE_INCLUDE_DIR=$STAGE_PATH/include \
    -DSPATIALITE_LIBRARY=$STAGE_PATH/lib/libspatialite.dylib \
    -DGDAL_USE_SQLITE3=ON \
    -DSQLITE3_INCLUDE_DIR=$STAGE_PATH/include \
    -DSQLITE3_LIBRARY=$STAGE_PATH/lib/libsqlite3.dylib \
    -DGDAL_USE_PNG=ON \
    -DPNG_PNG_INCLUDE_DIR=$STAGE_PATH/include \
    -DPNG_LIBRARY_RELEASE=$STAGE_PATH/lib/libpng.dylib \
    -DGDAL_USE_FREEXL=ON \
    -DFREEXL_INCLUDE_DIR=$STAGE_PATH/include \
    -DFREEXL_LIBRARY=$STAGE_PATH/lib/libfreexl.dylib \
    -DGDAL_USE_LIBKML=ON \
    -DLIBKML_INCLUDE_DIR=$STAGE_PATH/include \
    -DLIBKML_BASE_LIBRARY=$STAGE_PATH/lib/libkmlbase.dylib \
    -DLIBKML_DOM_LIBRARY=$STAGE_PATH/lib/libkmldom.dylib \
    -DLIBKML_ENGINE_LIBRARY=$STAGE_PATH/lib/libkmlengine.dylib \
    -DLIBKML_MINIZIP_LIBRARY=$STAGE_PATH/lib/libminizip.dylib \
    -DLIBKML_URIPARSER_LIBRARY=$STAGE_PATH/lib/liburiparser.dylib \
    -DGDAL_USE_XERCESC=ON \
    -DXercesC_INCLUDE_DIR=$STAGE_PATH/include \
    -DXercesC_LIBRARY=$STAGE_PATH/lib/libxerces-c.dylib \
    -DGDAL_USE_EXPAT=ON \
    -DEXPAT_INCLUDE_DIR=$STAGE_PATH/include \
    -DEXPAT_LIBRARY=$STAGE_PATH/lib/libexpat.dylib \
    -DGDAL_USE_POPPLER=ON \
    -DPOPPLER_INCLUDE_DIR=$STAGE_PATH/include/poppler \
    -DPOPPLER_LIBRARY=$STAGE_PATH/lib/libpoppler.dylib \
    -DGDAL_USE_OPENSSL=ON \
    -DOPENSSL_INCLUDE_DIR=$STAGE_PATH/include \
    -DOPENSSL_CRYPTO_LIBRARY=$STAGE_PATH/lib/libcrypto.dylib \
    -DGDAL_USE_MYSQL=ON \
    -DMYSQL_INCLUDE_DIR=$STAGE_PATH/include/mysql \
    -DMYSQL_LIBRARY=$STAGE_PATH/lib/libmysqlclient.dylib

  # check_file_configuration config.status
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  build_ecw
  build_mrsid

  # fixes for install names
  try fix_install_name lib/$LINK_gdal
  try fix_install_name bin/gdal-config
  try fix_install_name bin/gdal_contour
  try fix_install_name bin/gdal_create
  try fix_install_name bin/gdal_grid
  try fix_install_name bin/gdal_rasterize
  try fix_install_name bin/gdal_translate
  try fix_install_name bin/gdal_viewshed
  try fix_install_name bin/gdaladdo
  try fix_install_name bin/gdalbuildvrt
  try fix_install_name bin/gdaldem
  try fix_install_name bin/gdalenhance
  try fix_install_name bin/gdalinfo
  try fix_install_name bin/gdallocationinfo
  try fix_install_name bin/gdalmanage
  try fix_install_name bin/gdalmdiminfo
  try fix_install_name bin/gdalmdimtranslate
  try fix_install_name bin/gdalsrsinfo
  try fix_install_name bin/gdaltindex
  try fix_install_name bin/gdaltransform
  try fix_install_name bin/gdalwarp
  try fix_install_name bin/ogr2ogr
  try fix_install_name bin/ogrinfo
  try fix_install_name bin/ogrlineref
  try fix_install_name bin/ogrtindex

  if [[ "$WITH_ECW" == "true" ]]; then
    try fix_install_name $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_ecw}
  fi

  if [[ "$MRSID_SDK" == "true" ]]; then
    try fix_install_name $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_lidar}
    try fix_install_name $GDAL_NOFOSS_PLUGINS_DIR/${LINK_gdal_mrsid_raster}
  fi

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
