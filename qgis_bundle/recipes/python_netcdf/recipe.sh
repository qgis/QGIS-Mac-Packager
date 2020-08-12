#!/bin/bash

function check_python_netcdf() {
  env_var_exists VERSION_python_netcdf
}

function bundle_python_netcdf() {
  :
}

function postbundle_python_netcdf() {
 NETCDF_EGG=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $NETCDF_EGG/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $NETCDF_EGG/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $NETCDF_EGG/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so
}

