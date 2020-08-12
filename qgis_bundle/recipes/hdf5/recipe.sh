#!/bin/bash

function check_hdf5() {
  env_var_exists VERSION_hdf5
  env_var_exists LINK_libhdf5
}

function bundle_hdf5() {
    try cp -av $DEPS_LIB_DIR/libhdf5.*dylib $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libhdf5_hl.*dylib $BUNDLE_LIB_DIR
}

function postbundle_hdf5() {

 install_name_id @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5
 install_name_id @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5_hl

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5_hl
  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5_hl
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5
}
