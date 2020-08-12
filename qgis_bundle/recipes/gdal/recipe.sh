#!/bin/bash

function check_gdal() {
  env_var_exists VERSION_gdal
  env_var_exists LINK_gdal
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_gdal() {
  try cp -av $DEPS_LIB_DIR/libgdal*dylib $BUNDLE_LIB_DIR

  # GDAL binaries
  for i in \
    gdal_contour \
    gdal_grid \
    gdal_rasterize \
    gdal_translate \
    gdal_viewshed \
    gdaladdo \
    gdalbuildvrt \
    gdaldem \
    gdalenhance \
    gdalinfo \
    gdallocationinfo \
    gdalmanage \
    gdalmdiminfo \
    gdalmdimtranslate \
    gdalserver \
    gdalsrsinfo \
    gdaltindex \
    gdaltransform \
    gdalwarp
  do
    try cp -av $DEPS_BIN_DIR/$i $BUNDLE_BIN_DIR/$i
  done

  # GDAL plugins
  # https://github.com/qgis/QGIS/blob/518cc16e87aba6798658acf75c86f27a0f4d99b3/src/app/main.cpp#L1198
  # should be in Contents/MacOS/lib/gdalplugins
  # we do not have any gdalplugins yet
  try mkdir $BUNDLE_CONTENTS_DIR/MacOS/lib/gdalplugins

  # GDAL data
  # https://github.com/qgis/QGIS/blob/518cc16e87aba6798658acf75c86f27a0f4d99b3/src/app/main.cpp#L1205
  # should be Contents/Resources/gdal
  try rsync -av $DEPS_SHARE_DIR/gdal $BUNDLE_RESOURCES_DIR/
}

function postbundle_gdal() {
  install_name_id @rpath/$LINK_gdal $BUNDLE_LIB_DIR/$LINK_gdal

  for i in \
    bin/gdal_contour \
    bin/gdal_grid \
    bin/gdal_rasterize \
    bin/gdal_translate \
    bin/gdal_viewshed \
    bin/gdaladdo \
    bin/gdalbuildvrt \
    bin/gdaldem \
    bin/gdalenhance \
    bin/gdalinfo \
    bin/gdallocationinfo \
    bin/gdalmanage \
    bin/gdalmdiminfo \
    bin/gdalmdimtranslate \
    bin/gdalserver \
    bin/gdalsrsinfo \
    bin/gdaltindex \
    bin/gdaltransform \
    bin/gdalwarp \
    lib/$LINK_gdal
  do
      for j in \
        $LINK_freexl \
        $LINK_libgeos_c \
        $LINK_libhdf5 \
        $LINK_netcdf \
        $LINK_jpeg \
        $LINK_libtiff \
        $LINK_libxml2 \
        $LINK_libcrypto \
        $LINK_libpng \
        $LINK_libpq \
        $LINK_libproj \
        $LINK_spatialite \
        $LINK_sqlite \
        $LINK_libwebp \
        $LINK_libxerces_c \
        $LINK_zlib \
        $LINK_zstd \
        $LINK_gdal
      do
        install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_CONTENTS_DIR/MacOS/$i
      done
  done


}

