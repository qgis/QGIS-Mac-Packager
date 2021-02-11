#!/bin/bash

function check_python_netcdf() {
  env_var_exists VERSION_python_netcdf4
}

function bundle_python_netcdf() {
  :
}

function fix_binaries_python_netcdf() {
  NETCDF_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg

  for i in \
    $LINK_libhdf5 \
    $LINK_libhdf5_hl \
    $LINK_netcdf
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $NETCDF_EGG/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}-darwin.so
  done
}

function fix_binaries_python_netcdf_check() {
  NETCDF_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg

  verify_binary $NETCDF_EGG/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}-darwin.so
}

function fix_paths_python_netcdf() {
  :
}

function fix_paths_python_netcdf_check() {
  :
}
