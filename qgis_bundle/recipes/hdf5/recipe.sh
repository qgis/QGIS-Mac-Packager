#!/bin/bash

function check_hdf5() {
  env_var_exists VERSION_hdf5
  env_var_exists LINK_libhdf5
}

function bundle_hdf5() {
  try cp -av $DEPS_LIB_DIR/libhdf5.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libhdf5_hl.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_hdf5() {
 install_name_id @rpath/$LINK_libhdf5 $BUNDLE_LIB_DIR/$LINK_libhdf5
 install_name_id @rpath/$LINK_libhdf5_hl $BUNDLE_LIB_DIR/$LINK_libhdf5_hl

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_LIB_DIR/$LINK_libhdf5
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_LIB_DIR/$LINK_libhdf5_hl
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_libhdf5_hl
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_libhdf5
}

function fix_binaries_hdf5_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libhdf5
  verify_binary $BUNDLE_LIB_DIR/$LINK_libhdf5_hl
}

function fix_paths_hdf5() {
  :
}

function fix_paths_hdf5_check() {
  :
}