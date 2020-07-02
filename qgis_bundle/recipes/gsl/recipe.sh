#!/bin/bash

function check_gsl() {
  env_var_exists VERSION_gsl
  env_var_exists LINK_libgsl
  env_var_exists LINK_libgslcblas
}

function bundle_gsl() {
    try cp -av $DEPS_LIB_DIR/libgsl.*dylib $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libgslcblas.*dylib $BUNDLE_LIB_DIR
}

function postbundle_gsl() {
 install_name_id  @rpath/$LINK_libgsl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libgsl
 install_name_id  @rpath/$LINK_libgslcblas $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libgslcblas

 # install_name_change $DEPS_LIB_DIR/$LINK_libgsl @rpath/$LINK_libgsl $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeorefplugin.so
 # install_name_change $DEPS_LIB_DIR/$LINK_libgslcblas @rpath/$LINK_libgslcblas $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeorefplugin.so

 install_name_change $DEPS_LIB_DIR/$LINK_libgsl @rpath/$LINK_libgsl $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_libgslcblas @rpath/$LINK_libgslcblas $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so

 install_name_change $DEPS_LIB_DIR/$LINK_libgsl @rpath/$LINK_libgsl $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libgslcblas @rpath/$LINK_libgslcblas $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
}

function add_config_info_gsl() {
    :
}

