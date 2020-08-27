#!/bin/bash

function check_python_pillow() {
  env_var_exists VERSION_python_pillow
}

function bundle_python_pillow() {
  # the pillow.egg is zip file, unzip it to be able to fix binaries
  cd $BUNDLE_PYTHON_SITE_PACKAGES_DIR

  try unzip pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg -d _tmp_pillow
  try rm -rf pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
  try mv _tmp_pillow pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
}

function fix_binaries_python_pillow() {
  pillow_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    _list \
    _datadir \
    _crs \
    _geod \
    _proj \
    _transformer
  do
    :
    # install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $pillow_EGG/pillow/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_pillow_check() {
  pillow_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  # verify_binary $pillow_EGG/pillow/_proj.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_pillow() {
  :
}

function fix_paths_python_pillow_check() {
  :
}