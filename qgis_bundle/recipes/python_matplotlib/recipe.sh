#!/bin/bash

function check_python_matplotlib() {
  env_var_exists VERSION_python_matplotlib
}

function bundle_python_matplotlib() {
  :
}

function fix_binaries_python_matplotlib() {
  MATPLOTLIB_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/matplotlib-${VERSION_python_matplotlib}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    backends/_backend_agg \
    ft2font
  do
    install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $MATPLOTLIB_EGG_DIR/matplotlib/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_matplotlib_check() {
  MATPLOTLIB_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/matplotlib-${VERSION_python_matplotlib}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  verify_binary $MATPLOTLIB_EGG_DIR/matplotlib/ft2font.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_matplotlib() {
  :
}

function fix_paths_python_matplotlib_check() {
  :
}