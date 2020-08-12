#!/bin/bash

function check_protobuf() {
  env_var_exists VERSION_protobuf
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists LINK_protobuf_lite
}

function bundle_protobuf() {
  try cp -av $DEPS_LIB_DIR/libprotobuf-lite.*dylib $BUNDLE_LIB_DIR
}

function postbundle_protobuf() {
  install_name_id @rpath/$LINK_protobuf_lite $BUNDLE_LIB_DIR/$LINK_protobuf_lite

  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_protobuf_lite
}
