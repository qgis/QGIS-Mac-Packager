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

function fix_binaries_exiv2() {
  install_name_id @rpath/$LINK_exiv2 $BUNDLE_LIB_DIR/$LINK_exiv2

  for i in \
    $LINK_expat \
    $LINK_zlib
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_exiv2
  done
}

function fix_binaries_exiv2_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_exiv2
}

function fix_paths_exiv2() {
  :
}

function fix_paths_exiv2_check() {
  :
}