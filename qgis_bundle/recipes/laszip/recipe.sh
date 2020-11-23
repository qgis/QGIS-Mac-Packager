#!/bin/bash

function check_laszip() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    env_var_exists VERSION_laszip
    env_var_exists LINK_liblaszip
  fi
}

function bundle_laszip() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    try cp -av $DEPS_LIB_DIR/liblaszip.*dylib $BUNDLE_LIB_DIR
  fi
}

function fix_binaries_laszip() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    install_name_id @rpath/$LINK_liblaszip $BUNDLE_LIB_DIR/$LINK_liblaszip
  fi
}

function fix_binaries_laszip_check() {
  if [[ "$WITH_PDAL" == "true" ]]; then
    verify_binary $BUNDLE_LIB_DIR/$LINK_liblaszip
  fi
}

function fix_paths_laszip() {
  :
}

function fix_paths_laszip_check() {
  :
}
