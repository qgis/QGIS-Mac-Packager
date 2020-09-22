#!/bin/bash

function check_freetds() {
  env_var_exists VERSION_freetds
  env_var_exists LINK_ct
  env_var_exists LINK_sybdb
  env_var_exists LINK_tdsodbc
}

function bundle_freetds() {
  try cp -av $DEPS_LIB_DIR/libct.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libsybdb.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libtdsodbc.*so $BUNDLE_LIB_DIR
}

function fix_binaries_freetds() {
  for i in \
    $LINK_ct \
    $LINK_sybdb \
    $LINK_tdsodbc
  do
    install_name_id  @rpath/$i $BUNDLE_LIB_DIR/$i

    for j in \
      $LINK_libssl \
      $LINK_libcrypto \
      $LINK_libltdl
    do
      install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_LIB_DIR/$i
    done

    install_name_change $QGIS_DEPS_STAGE_PATH/unixodbc/lib/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_LIB_DIR/$i
    install_name_change $QGIS_DEPS_STAGE_PATH/unixodbc/lib/$LINK_unixodbcinst @rpath/$LINK_unixodbcinst $BUNDLE_LIB_DIR/$i

  done
}

function fix_binaries_freetds_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_ct
  verify_binary $BUNDLE_LIB_DIR/$LINK_sybdb
  verify_binary $BUNDLE_LIB_DIR/$LINK_tdsodbc
}

function fix_paths_freetds() {
  :
}

function fix_paths_freetds_check() {
  :
}