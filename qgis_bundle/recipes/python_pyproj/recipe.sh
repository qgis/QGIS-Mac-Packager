#!/bin/bash

PYPROJ_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/pyproj-${VERSION_python_pyproj}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

function check_python_pyproj() {
  env_var_exists VERSION_python_pyproj
}

function bundle_python_pyproj() {
  :
}

function fix_binaries_python_pyproj() {
  PYPROJ_LIBS=
  if [[ "$OLD_PROJ" == "true" ]]; then
    PYPROJ_LIBS=(
      _list \
      _datadir \
      _crs \
      _geod \
      _proj \
      _transformer
    )
  else
    PYPROJ_LIBS=(
      _compat \
      list \
      _datadir \
      _crs \
      _geod \
      _network \
      _sync \
      database \
      _transformer
    )
  fi

  for i in "${PYPROJ_LIBS[@]}"
  do
    install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/$i.cpython-${VERSION_major_python//./}-darwin.so
  done
}

function fix_binaries_python_pyproj_check() {
  verify_binary $PYPROJ_EGG/pyproj/_datadir.cpython-${VERSION_major_python//./}-darwin.so
}

function fix_paths_python_pyproj() {
  try cp -av $RECIPES_PATH/python_pyproj/_patch_proj_lib.py $PYPROJ_EGG/pyproj/_patch_proj_lib.py

  try ${SED} "s;from pyproj import _datadir;from pyproj import _patch_proj_lib, _datadir;g" $PYPROJ_EGG/pyproj/__init__.py
}

function fix_paths_python_pyproj_check() {
  :
}