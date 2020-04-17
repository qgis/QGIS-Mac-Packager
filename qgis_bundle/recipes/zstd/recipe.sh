#!/bin/bash

function check_zstd() {
  env_var_exists VERSION_zstd
}

function bundle_zstd() {
    try cp -av $DEPS_LIB_DIR/libzstd.*dylib $BUNDLE_LIB_DIR
}

function postbundle_zstd() {
 install_name_id  @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_zstd

 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libmysqlclient
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

}

function add_config_info_zstd() {
    :
}
