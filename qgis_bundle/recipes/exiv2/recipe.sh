#!/bin/bash

function check_exiv2() {
  env_var_exists VERSION_exiv2
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists LINK_exiv2
}

function bundle_exiv2() {
    try cp -av $DEPS_LIB_DIR/libexiv2.*dylib $BUNDLE_LIB_DIR
}

function postbundle_exiv2() {
    install_name_id @rpath/$LINK_exiv2 $BUNDLE_LIB_DIR/$LINK_exiv2

     install_name_change $DEPS_LIB_DIR/$LINK_exiv2 @rpath/$LINK_exiv2 $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $DEPS_LIB_DIR/$LINK_exiv2 @rpath/$LINK_exiv2 $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis
 install_name_change $DEPS_LIB_DIR/$LINK_exiv2 @rpath/$LINK_exiv2 $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_exiv2 @rpath/$LINK_exiv2 $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_exiv2 @rpath/$LINK_exiv2 $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $DEPS_LIB_DIR/$LINK_exiv2 @rpath/$LINK_exiv2 $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
}

function add_config_info_exiv2() {
    :
}
