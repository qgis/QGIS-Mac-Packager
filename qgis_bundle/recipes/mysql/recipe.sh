#!/bin/bash

function check_mysql() {
  env_var_exists VERSION_mysql
}

function bundle_mysql() {
  try cp -av $DEPS_LIB_DIR/libmysqlclient.*dylib $BUNDLE_LIB_DIR
}

function postbundle_mysql() {
  for i in \
    $LINK_libcrypto \
    $LINK_libssl \
    $LINK_zstd
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libmysqlclient
  done
}
