#!/bin/bash

function check_bz2() {
  env_var_exists VERSION_bz2
}

function bundle_bz2() {
    try cp -av $DEPS_LIB_DIR/libbz2.* $BUNDLE_LIB_DIR
}

function postbundle_bz2() {
 install_name_id @rpath/$LINK_bz2 $BUNDLE_LIB_DIR/$LINK_bz2
}
