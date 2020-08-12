#!/bin/bash

function check_fontconfig() {
  env_var_exists VERSION_fontconfig
}

function bundle_fontconfig() {
    try cp -av $DEPS_LIB_DIR/libfontconfig.* $BUNDLE_LIB_DIR
}

function postbundle_fontconfig() {
 install_name_id @rpath/$LINK_fontconfig $BUNDLE_LIB_DIR/$LINK_fontconfig

 install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_LIB_DIR/$LINK_fontconfig
 install_name_change $DEPS_LIB_DIR/$LINK_expat @rpath/$LINK_expat $BUNDLE_LIB_DIR/$LINK_fontconfig
 install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $BUNDLE_LIB_DIR/$LINK_fontconfig
 install_name_change $DEPS_LIB_DIR/$LINK_libintl @rpath/$LINK_libintl $BUNDLE_LIB_DIR/$LINK_fontconfig
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_fontconfig
}
