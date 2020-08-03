#!/bin/bash

function check_fontconfig() {
  env_var_exists VERSION_fontconfig
}

function bundle_fontconfig() {
    try cp -av $DEPS_LIB_DIR/libfontconfig.* $BUNDLE_LIB_DIR
}

function postbundle_fontconfig() {
 install_name_id @rpath/$LINK_fontconfig $BUNDLE_LIB_DIR/$LINK_fontconfig

 # install_name_change $DEPS_LIB_DIR/$LINK_libquadmath @rpath/$LINK_libquadmath $BUNDLE_LIB_DIR/$LINK_libgfortran
}
