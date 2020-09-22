#!/bin/bash

function check_unixodbc() {
  env_var_exists VERSION_unixodbc
  env_var_exists LINK_unixodbc
  env_var_exists LINK_unixodbcinst
}

function bundle_unixodbc() {
  try cp -av $QGIS_DEPS_STAGE_PATH/unixodbc/lib/libodbc.*dylib $BUNDLE_LIB_DIR
  try cp -av $QGIS_DEPS_STAGE_PATH/unixodbc/lib/libodbcinst.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_unixodbc() {
  install_name_id @rpath/$LINK_unixodbc $BUNDLE_LIB_DIR/$LINK_unixodbc
  install_name_id @rpath/$LINK_unixodbcinst $BUNDLE_LIB_DIR/$LINK_unixodbcinst

  install_name_change $DEPS_LIB_DIR/$LINK_libltdl @rpath/$LINK_libltdl $BUNDLE_LIB_DIR/$LINK_unixodbc
  install_name_change $DEPS_LIB_DIR/$LINK_libltdl @rpath/$LINK_libltdl $BUNDLE_LIB_DIR/$LINK_unixodbcinst
}

function fix_binaries_unixodbc_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_unixodbc
  verify_binary $BUNDLE_LIB_DIR/$LINK_unixodbcinst
}

function fix_paths_unixodbc() {
  :
}

function fix_paths_unixodbc_check() {
  :
}