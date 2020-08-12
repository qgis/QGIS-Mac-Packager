#!/bin/bash

function check_openblas() {
  env_var_exists VERSION_openblas
  env_var_exists LINK_libopenblas
}

function bundle_openblas() {
  try cp -av $DEPS_LIB_DIR/libopenblas*dylib $BUNDLE_LIB_DIR
}

function postbundle_openblas() {
  install_name_id  @rpath/$LINK_libopenblas $BUNDLE_LIB_DIR/$LINK_libopenblas
  install_name_id  @rpath/$LINK_libopenblas_haswellp $BUNDLE_LIB_DIR/$LINK_libopenblas_haswellp

  for i in \
    $LINK_libopenblas \
    $LINK_libquadmath \
    $LINK_libgfortran \
    $LINK_gcc_s
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libopenblas_haswellp
  done
}
