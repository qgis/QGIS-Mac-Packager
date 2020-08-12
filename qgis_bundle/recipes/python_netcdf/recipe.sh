#!/bin/bash

function check_python_netcdf() {
  env_var_exists VERSION_python_netcdf
}

function bundle_python_netcdf() {
  :
}

function postbundle_python_netcdf() {
  NETCDF_EGG=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg

  for i in \
    $LINK_libhdf5 \
    $LINK_libhdf5_hl \
    $LINK_netcdf
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $NETCDF_EGG/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

