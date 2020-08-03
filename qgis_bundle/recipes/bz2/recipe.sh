#!/bin/bash

function check_bz2() {
  env_var_exists VERSION_bz2
}

function bundle_bz2() {
    try cp -av $DEPS_LIB_DIR/libbz2.* $BUNDLE_LIB_DIR
}

function postbundle_bz2() {
 install_name_id @rpath/$LINK_bz2 $BUNDLE_LIB_DIR/$LINK_bz2

 install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_bz2.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_freetype
 install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_LIB_DIR/$LINK_fontconfig
 install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_LIB_DIR/$LINK_libzip
}
