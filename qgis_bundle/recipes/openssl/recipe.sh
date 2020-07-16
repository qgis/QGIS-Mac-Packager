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

 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libmysqlclient
 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libmysqlclient

 install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_ssl.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_hashlib.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/psycopg2/_psycopg.cpython-${VERSION_major_python//./}m-darwin.so

 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_ssl.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_hashlib.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/psycopg2/_psycopg.cpython-${VERSION_major_python//./}m-darwin.so

 install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/PlugIns/crypto/libqca-ossl.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/PlugIns/crypto/libqca-ossl.dylib
}

