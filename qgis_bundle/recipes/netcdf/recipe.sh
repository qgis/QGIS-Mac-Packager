#!/bin/bash

function check_netcdf() {
  env_var_exists VERSION_netcdf
}

function bundle_netcdf() {
  try cp -av $DEPS_LIB_DIR/libnetcdf.*dylib $BUNDLE_LIB_DIR
}

function postbundle_netcdf() {
 install_name_id @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_netcdf

 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so
}
