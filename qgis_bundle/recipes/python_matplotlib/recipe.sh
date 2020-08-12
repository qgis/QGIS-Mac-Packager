#!/bin/bash

function check_python_matplotlib() {
  env_var_exists VERSION_python_matplotlib
}

function bundle_python_matplotlib() {
  :
}

function postbundle_python_matplotlib() {
  MATPLOTLIB_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/matplotlib-${VERSION_python_matplotlib}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    backends/_backend_agg \
    ft2font
  do
    install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $MATPLOTLIB_EGG_DIR/matplotlib/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

