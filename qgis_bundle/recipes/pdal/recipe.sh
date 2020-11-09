#!/bin/bash

function check_pdal() {
  env_var_exists VERSION_pdal
  env_var_exists LINK_libpdalcpp
  env_var_exists LINK_libpdal_util
}

function bundle_pdal() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    try cp -av $DEPS_LIB_DIR/libpdalcpp.*dylib $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libpdal_util.*dylib $BUNDLE_LIB_DIR
  fi
}

function fix_binaries_pdal() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    install_name_id @rpath/$LINK_libpdalcpp $BUNDLE_LIB_DIR/$LINK_libpdalcpp
    install_name_id @rpath/$LINK_libpdal_util $BUNDLE_LIB_DIR/$LINK_libpdal_util

    for i in \
        $LINK_libssl \
        $LINK_libcrypto \
        $LINK_libpdal_util \
        $LINK_zstd \
        $LINK_zlib \
        $LINK_libxml2 \
        $LINK_liblaszip \
        $LINK_gdal
      do
         install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libpdalcpp
      done
  fi
}

function fix_binaries_pdal_check() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    verify_binary $BUNDLE_LIB_DIR/$LINK_libpdalcpp
    verify_binary $BUNDLE_LIB_DIR/$LINK_libpdal_util
  fi
}

function fix_paths_pdal() {
  :
}

function fix_paths_pdal_check() {
  :
}
