#!/bin/bash

function check_openblas() {
  env_var_exists VERSION_openblas
  env_var_exists LINK_libopenblas
}

function bundle_openblas() {
  try cp -av $DEPS_LIB_DIR/libopenblas*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_openblas() {
  install_name_id  @rpath/$LINK_libopenblas $BUNDLE_LIB_DIR/$LINK_libopenblas

  for i in \
    $LINK_libopenblas \
    $LINK_libquadmath \
    $LINK_libgfortran \
    $LINK_gcc_s
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libopenblas
  done
}

function fix_binaries_openblas_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libopenblas
}

function fix_paths_openblas() {
  :
}

function fix_paths_openblas_check() {
  :
}