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

function postbundle_gsl() {
  install_name_id  @rpath/$LINK_libgsl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libgsl
  install_name_id  @rpath/$LINK_libgslcblas $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libgslcblas
}
