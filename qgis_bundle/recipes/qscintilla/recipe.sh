#!/bin/bash

function check_qscintilla() {
  env_var_exists VERSION_qscintilla
  env_var_exists LINK_libqscintilla2_qt5
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_qscintilla() {
  try cp -av $DEPS_LIB_DIR/libqscintilla2_qt5*dylib $BUNDLE_LIB_DIR/
}

function fix_binaries_qscintilla() {
  install_name_delete_rpath $QT_BASE/lib $BUNDLE_LIB_DIR/${LINK_libqscintilla2_qt5}

  install_name_id @rpath/$LINK_libqscintilla2_qt5 $BUNDLE_LIB_DIR/$LINK_libqscintilla2_qt5
}

function fix_binaries_qscintilla_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libqscintilla2_qt5
}

function fix_paths_qscintilla() {
  :
}

function fix_paths_qscintilla_check() {
  :
}