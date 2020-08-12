#!/bin/bash

function check_gdal() {
  env_var_exists VERSION_gdal
  env_var_exists LINK_gdal
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_gdal() {
  try cp -av $DEPS_LIB_DIR/libgdal*dylib $BUNDLE_LIB_DIR

  # TODO GDAL binaries!!

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

 install_name_change $DEPS_LIB_DIR/$LINK_freexl @rpath/$LINK_freexl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libgeos_c @rpath/$LINK_libgeos_c $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libxml2 @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libpq @rpath/$LINK_libpq $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_spatialite @rpath/$LINK_spatialite $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_sqlite @rpath/$LINK_sqlite $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libwebp @rpath/$LINK_libwebp $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libxerces_c @rpath/$LINK_libxerces_c $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
}

