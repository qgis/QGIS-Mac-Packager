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
}

