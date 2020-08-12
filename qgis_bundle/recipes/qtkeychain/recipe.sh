#!/bin/bash

function check_qtkeychain() {
  env_var_exists VERSION_qtkeychain
  env_var_exists LINK_qtkeychain
  env_var_exists VERSION_grass_major
  env_var_exists QGIS_VERSION
}

function bundle_qtkeychain() {
    try cp -av $DEPS_LIB_DIR/libqt5keychain.* $BUNDLE_LIB_DIR
}

function postbundle_qtkeychain() {
 install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_qtkeychain

 install_name_id @rpath/$LINK_qtkeychain $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_qtkeychain

}

