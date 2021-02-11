#!/bin/bash

function check_python_rasterio() {
  env_var_exists VERSION_python_rasterio
}

function bundle_python_rasterio() {
  :
}

function fix_binaries_python_rasterio() {
  RASTERIO_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/rasterio-${VERSION_python_rasterio}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    _env \
    _base \
    _crs \
    _env \
    _err \
    _example \
    _features \
    _fill \
    _io \
    _shim \
    _transform \
    _warp \
    shutil
  do
    install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $RASTERIO_EGG_DIR/rasterio/$i.cpython-${VERSION_major_python//./}-darwin.so
  done
}

function fix_binaries_python_rasterio_check() {
  RASTERIO_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/rasterio-${VERSION_python_rasterio}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  verify_binary $RASTERIO_EGG_DIR/rasterio/_base.cpython-${VERSION_major_python//./}-darwin.so
}

function fix_paths_python_rasterio() {
  :
}

function fix_paths_python_rasterio_check() {
  :
}