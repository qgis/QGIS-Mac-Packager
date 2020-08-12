#!/bin/bash

function check_python_fiona() {
  env_var_exists VERSION_python_fiona
}

function bundle_python_fiona() {
  :
}

function postbundle_python_fiona() {
  FIONA_EGG=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/fiona-${VERSION_python_fiona}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    ogrext \
    _env \
    _transform \
    _crs \
    schema \
    _geometry \
    _shim \
    _err
  do
    install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $FIONA_EGG/fiona/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

