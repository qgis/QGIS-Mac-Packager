#!/bin/bash

function check_mysql() {
  env_var_exists VERSION_mysql
}

function bundle_mysql() {
    try cp -av $DEPS_LIB_DIR/libmysqlclient.*dylib $BUNDLE_LIB_DIR
}

function postbundle_mysql() {
    :
}
