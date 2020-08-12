#!/bin/bash

function check_spatialindex() {
  env_var_exists VERSION_spatialindex
  env_var_exists LINK_spatialindex
}

function bundle_spatialindex() {
    try cp -av $DEPS_LIB_DIR/libspatialindex*dylib $BUNDLE_LIB_DIR
}

function postbundle_spatialindex() {
 install_name_id @rpath/libspatialindex_c.6.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialindex_c
 install_name_id @rpath/$LINK_spatialindex $BUNDLE_LIB_DIR/$LINK_spatialindex
}
