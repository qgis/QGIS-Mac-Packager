#!/bin/bash

function check_libxml2() {
  env_var_exists VERSION_libxml2
  env_var_exists LINK_libxml2
}

function bundle_libxml2() {
    try cp -av $DEPS_LIB_DIR/libxml2.*dylib $BUNDLE_LIB_DIR
}

function postbundle_libxml2() {
 install_name_id @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libxml2

 install_name_change $DEPS_LIB_DIR/$LINK_libxml2 @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libxml2 @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libxslt
 install_name_change $DEPS_LIB_DIR/$LINK_libxml2 @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_libxml2 @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
}
