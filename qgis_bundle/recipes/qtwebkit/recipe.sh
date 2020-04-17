#!/bin/bash

function check_qtwebkit() {
  env_var_exists VERSION_qtwebkit
}

function bundle_qtwebkit() {
    try rsync -av $DEPS_LIB_DIR/QtWebKitWidgets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
    try rsync -av $DEPS_LIB_DIR/QtWebKit.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function postbundle_qtwebkit() {
    : # install_name_tool -id "@rpath/libqtwebkit.dylib" ${STAGE_PATH}/lib/libqtwebkit.dylib
}

function add_config_info_qtwebkit() {
    :
}
