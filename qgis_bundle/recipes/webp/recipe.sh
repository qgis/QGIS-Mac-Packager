#!/bin/bash

function check_webp() {
  env_var_exists VERSION_webp
}

function bundle_webp() {
    try cp -av $DEPS_LIB_DIR/libwebp.*dylib $BUNDLE_LIB_DIR
}

function postbundle_webp() {
 install_name_id @rpath/libwebp.7.dylib $BUNDLE_LIB_DIR/libwebp.7.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwebp.7.dylib @rpath/libwebp.7.dylib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwebp.7.dylib @rpath/libwebp.7.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwebp.7.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwebp.7.dylib @rpath/libwebp.7.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libtiff.5.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwebp.7.dylib @rpath/libwebp.7.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib
}

function add_config_info_webp() {
    :
}
