#!/bin/bash

function check_python_psycopg2() {
  env_var_exists VERSION_python_psycopg2
}

function bundle_python_psycopg2() {
  :
}

function postbundle_python_psycopg2() {
  for i in \
    $LINK_libssl \
    $LINK_libcrypto \
    $LINK_libpq
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/psycopg2/_psycopg.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

