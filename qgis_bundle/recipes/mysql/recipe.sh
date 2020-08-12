#!/bin/bash

function check_mysql() {
  env_var_exists VERSION_mysql
}

function bundle_mysql() {
    try cp -av $DEPS_LIB_DIR/libmysqlclient.*dylib $BUNDLE_LIB_DIR
}

function postbundle_mysql() {
    install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libmysqlclient
    install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libmysqlclient
    install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libmysqlclient
}
