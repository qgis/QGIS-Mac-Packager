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
 install_name_id @rpath/libhdf5_hl.100.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libhdf5_hl.100.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_netcdf
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/libhdf5_hl.100.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libhdf5_hl.100.dylib @rpath/libhdf5_hl.100.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libnetcdf.15.dylib
}

function add_config_info_hdf5() {
    :
}
