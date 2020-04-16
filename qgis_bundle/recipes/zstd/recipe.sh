#!/bin/bash

function check_zstd() {
  env_var_exists VERSION_zstd
}

function bundle_zstd() {
    try cp -av $DEPS_LIB_DIR/libzstd.*dylib $BUNDLE_LIB_DIR
}

function postbundle_zstd() {
 install_name_id  @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_zstd

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/libmysqlclient.21.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/libtiff.5.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib

}

function add_config_info_zstd() {
    :
}
