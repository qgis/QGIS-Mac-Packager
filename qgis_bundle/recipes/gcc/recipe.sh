#!/bin/bash

function check_gcc() {
  env_var_exists VERSION_gcc
}

function bundle_gcc() {
  try cp -av $DEPS_LIB_DIR/libgfortran.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libgcc_s.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libquadmath.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_gcc() {
 install_name_id @rpath/$LINK_libgfortran $BUNDLE_LIB_DIR/$LINK_libgfortran
 install_name_id @rpath/$LINK_libquadmath $BUNDLE_LIB_DIR/$LINK_libquadmath
 install_name_id @rpath/$LINK_gcc_s $BUNDLE_LIB_DIR/$LINK_gcc_s

 install_name_change $DEPS_LIB_DIR/$LINK_libquadmath @rpath/$LINK_libquadmath $BUNDLE_LIB_DIR/$LINK_libgfortran
 install_name_change $DEPS_LIB_DIR/$LINK_gcc_s @rpath/$LINK_gcc_s $BUNDLE_LIB_DIR/$LINK_libgfortran
 install_name_change $DEPS_LIB_DIR/$LINK_gcc_s @rpath/$LINK_gcc_s $BUNDLE_LIB_DIR/$LINK_libquadmath
}

function fix_binaries_gcc_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libgfortran
  verify_binary $BUNDLE_LIB_DIR/$LINK_libquadmath
  verify_binary $BUNDLE_LIB_DIR/$LINK_gcc_s
}

function fix_paths_gcc() {
  :
}

function fix_paths_gcc_check() {
  :
}