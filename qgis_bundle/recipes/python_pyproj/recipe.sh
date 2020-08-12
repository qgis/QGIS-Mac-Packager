#!/bin/bash

function check_python_pyproj() {
  env_var_exists VERSION_python_pyproj
}

function bundle_python_pyproj() {
  :
}

function postbundle_python_pyproj() {
  PYPROJ_EGG=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-${VERSION_python_pyproj}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    _list \
    _datadir \
    _crs \
    _geod \
    _proj \
    _transformer
  do
    install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

