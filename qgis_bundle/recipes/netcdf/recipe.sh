#!/bin/bash

function check_netcdf() {
  env_var_exists VERSION_netcdf
}

function bundle_netcdf() {
  try cp -av $DEPS_LIB_DIR/libnetcdf.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_netcdf() {
  install_name_id @rpath/$LINK_netcdf $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_netcdf

  for i in \
    $LINK_libhdf5 \
    $LINK_libhdf5_hl \
    $LINK_zlib \
    $LINK_libcurl
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_netcdf
  done
}

function fix_binaries_netcdf_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_netcdf
}

function fix_paths_netcdf() {
  :
}

function fix_paths_netcdf_check() {
  :
}