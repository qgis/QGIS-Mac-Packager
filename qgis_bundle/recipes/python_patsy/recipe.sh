#!/bin/bash

function check_python_patsy() {
  env_var_exists VERSION_python_patsy
}

function bundle_python_patsy() {
  # the patsy.egg is zip file, unzip it to be able to fix binaries
  cd $BUNDLE_PYTHON_SITE_PACKAGES_DIR

  try unzip patsy-${VERSION_python_patsy}-py${VERSION_major_python}.egg -d _tmp_patsy
  try rm -rf patsy-${VERSION_python_patsy}-py${VERSION_major_python}.egg
  try mv _tmp_patsy patsy-${VERSION_python_patsy}-py${VERSION_major_python}.egg
}

function fix_binaries_python_patsy() {
  patsy_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/patsy-${VERSION_python_patsy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    _list \
    _datadir \
    _crs \
    _geod \
    _proj \
    _transformer
  do
    :
    # install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $patsy_EGG/patsy/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_patsy_check() {
  patsy_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/patsy-${VERSION_python_patsy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  # verify_binary $patsy_EGG/patsy/_proj.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_patsy() {
  :
}

function fix_paths_python_patsy_check() {
  :
}