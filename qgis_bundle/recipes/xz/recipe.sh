#!/bin/bash

function check_xz() {
  env_var_exists VERSION_xz
  env_var_exists LINK_liblzma
}

function bundle_xz() {
  try cp -av $DEPS_LIB_DIR/liblzma.*dylib $BUNDLE_LIB_DIR
}

function postbundle_xz() {
    install_name_id @rpath/$LINK_liblzma $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_liblzma
    install_name_change $DEPS_LIB_DIR/$LINK_liblzma @rpath/$LINK_liblzma $BUNDLE_CONTENTS_DIR/MacOS/lib/libzip.5.1.dylib
    install_name_change $DEPS_LIB_DIR/$LINK_liblzma @rpath/$LINK_liblzma $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_lzma.cpython-37m-darwin.so
}

function add_config_info_xz() {
    :
}
