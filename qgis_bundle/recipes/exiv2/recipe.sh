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

    install_name_change $DEPS_LIB_DIR/$LINK_expat @rpath/$LINK_expat $BUNDLE_LIB_DIR/$LINK_exiv2
    install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_exiv2
}
