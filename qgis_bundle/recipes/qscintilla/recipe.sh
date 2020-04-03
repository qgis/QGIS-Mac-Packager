#!/bin/bash

function check_qscintilla() {
  env_var_exists VERSION_qscintilla
  env_var_exists LINK_libqscintilla2_qt5
}

function bundle_qscintilla() {
    try cp -av $DEPS_LIB_DIR/libqscintilla2* $BUNDLE_LIB_DIR/
    : # install_name_tool -id "@rpath/libqscintilla.dylib" ${STAGE_PATH}/lib/libqscintilla.dylib
}

function postbundle_qscintilla() {
    install_name_tool -id $RPATH_LIB_DIR/$LINK_libqscintilla2_qt5 $BUNDLE_LIB_DIR/$LINK_libqscintilla2_qt5

    try install_name_tool -change $DEPS_LIB_DIR/$LINK_libqscintilla2_qt5 $RPATH_LIB_DIR/$LINK_libqscintilla2_qt5 $BUNDLE_PLUGINS_DIR/qgis/libgeometrycheckerplugin.so
}

function add_config_info_qscintilla() {
    :
}