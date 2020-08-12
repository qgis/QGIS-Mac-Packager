#!/bin/bash

function check_python_rasterio() {
  env_var_exists VERSION_python_rasterio
}

function bundle_python_rasterio() {
  :
}

function postbundle_python_rasterio() {
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
    install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/rasterio/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

