#!/bin/bash

function check_gsl() {
  env_var_exists VERSION_gsl
  env_var_exists LINK_libgsl
  env_var_exists LINK_libgslcblas
}

function bundle_gsl() {
  try cp -av $DEPS_LIB_DIR/libgsl.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libgslcblas.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_gsl() {
  install_name_id  @rpath/$LINK_libgsl $BUNDLE_LIB_DIR/$LINK_libgsl
  install_name_id  @rpath/$LINK_libgslcblas $BUNDLE_LIB_DIR/$LINK_libgslcblas
}

function fix_binaries_gsl_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libgsl
  verify_binary $BUNDLE_LIB_DIR/$LINK_libgslcblas
}

function fix_paths_gsl() {
  :
}

function fix_paths_gsl_check() {
  :
}