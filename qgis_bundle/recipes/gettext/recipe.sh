#!/bin/bash

function check_gettext() {
  env_var_exists VERSION_gettext
}

function bundle_gettext() {
    try cp -av $DEPS_LIB_DIR/libintl.* $BUNDLE_LIB_DIR
}

function postbundle_gettext() {
 # TODO remove in qgis-deps-0.5.2
 export LINK_libintl=libintl.8.dylib

 install_name_id @rpath/$LINK_LINK_libintl $BUNDLE_LIB_DIR/$LINK_libintl

 install_name_change $DEPS_LIB_DIR/$LINK_libintl @rpath/$LINK_libintl $BUNDLE_LIB_DIR/$LINK_fontconfig
}
