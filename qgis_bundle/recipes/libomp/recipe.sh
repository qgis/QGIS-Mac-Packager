#!/bin/bash

function check_libomp() {
  env_var_exists VERSION_libomp
}

function bundle_libomp() {
    try cp -av $DEPS_LIB_DIR/libomp.* $BUNDLE_LIB_DIR
}

function postbundle_libomp() {
 install_name_id @rpath/$LINK_libomp $BUNDLE_LIB_DIR/$LINK_libomp

 # install_name_change $DEPS_LIB_DIR/$LINK_libquadmath @rpath/$LINK_libquadmath $BUNDLE_LIB_DIR/$LINK_libgfortran
}
