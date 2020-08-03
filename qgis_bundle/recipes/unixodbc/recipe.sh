#!/bin/bash

function check_unixodbc() {
  env_var_exists VERSION_unixodbc
  env_var_exists LINK_unixodbc
}

function bundle_unixodbc() {
  try cp -av $DEPS_LIB_DIR/libodbc.*dylib $BUNDLE_LIB_DIR
}

function postbundle_unixodbc() {
  install_name_id  @rpath/$LINK_unixodbc $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_unixodbc

  install_name_change $DEPS_LIB_DIR/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyodbc.cpython-${VERSION_major_python//./}m-darwin.so
}
