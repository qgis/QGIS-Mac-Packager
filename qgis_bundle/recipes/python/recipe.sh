#!/bin/bash

function check_python() {
  env_var_exists VERSION_python
}

function bundle_python() {
    try cp -av $DEPS_LIB_DIR/libpython*dylib $BUNDLE_LIB_DIR

    chmod 755 $BUNDLE_LIB_DIR/libpython*dylib
}

function postbundle_python() {
    install_name_id @rpath/$LINK_python $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_python

    install_name_change $DEPS_LIB_DIR/$LINK_python @rpath/$LINK_python $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib
}

function add_config_info_python() {
    :
}
