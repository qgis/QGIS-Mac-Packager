#!/bin/bash

function check_openssl() {
  env_var_exists VERSION_openssl
  env_var_exists LINK_libssl
  env_var_exists LINK_libcrypto
}

function bundle_openssl() {
    try cp -av $DEPS_LIB_DIR/libssl.*dylib $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libcrypto.*dylib $BUNDLE_LIB_DIR
}

function postbundle_openssl() {
 install_name_id  @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libssl
 install_name_id  @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libcrypto

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libcrypto.1.1.dylib @rpath/libcrypto.1.1.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libmysqlclient.21.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libcrypto.1.1.dylib @rpath/libcrypto.1.1.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libssl.1.1.dylib @rpath/libssl.1.1.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libmysqlclient.21.dylib

}

function add_config_info_openssl() {
    :
}

