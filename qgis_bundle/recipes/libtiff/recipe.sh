#!/bin/bash

function check_libtiff() {
  env_var_exists VERSION_libtiff
}

function bundle_libtiff() {
    try cp -av $DEPS_LIB_DIR/libtiff.*dylib $BUNDLE_LIB_DIR
}

function postbundle_libtiff() {
 install_name_id @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff

 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
 install_name_change $DEPS_LIB_DIR/$LINK_libwebp @rpath/$LINK_libwebp $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
}
