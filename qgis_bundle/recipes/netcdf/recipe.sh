#!/bin/bash

function check_netcdf() {
  env_var_exists VERSION_netcdf
}

function bundle_netcdf() {
  try cp -av $DEPS_LIB_DIR/libnetcdf.*dylib $BUNDLE_LIB_DIR
}

function postbundle_netcdf() {
 install_name_id @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_netcdf

 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_netcdf @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
}

function add_config_info_netcdf() {
    :
}
