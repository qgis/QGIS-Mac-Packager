#!/bin/bash

function check_freetype() {
  env_var_exists VERSION_freetype
}

function bundle_freetype() {
  try cp -av $DEPS_LIB_DIR/libfreetype.* $BUNDLE_LIB_DIR
}

function postbundle_freetype() {
  install_name_id @rpath/$LINK_freetype $BUNDLE_LIB_DIR/$LINK_freetype

  MATPLOTLIB_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/matplotlib-${VERSION_python_matplotlib}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/

  install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $MATPLOTLIB_EGG_DIR/matplotlib/backends/_backend_agg.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $MATPLOTLIB_EGG_DIR/matplotlib/ft2font.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $BUNDLE_LIB_DIR/$LINK_fontconfig
}
