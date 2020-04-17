#!/bin/bash

function check_python() {
  env_var_exists VERSION_python
}

function bundle_python() {
    try cp -av $DEPS_LIB_DIR/libpython*dylib $BUNDLE_LIB_DIR

    chmod 755 $BUNDLE_LIB_DIR/libpython*dylib
}

function postbundle_python() {
    install_name_id @rpath/libpython3.7m.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libpython3.7m.dylib

    install_name_change $DEPS_LIB_DIR/libpython3.7m.dylib @rpath/libpython3.7m.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.3.13.0.dylib
}

function add_config_info_python() {
    :
}
