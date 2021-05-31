#!/bin/bash

function check_libyaml() {
  # added in qgis_deps-0.8.0
  # env_var_exists VERSION_libyaml
  # env_var_exists LINK_libyaml
  :
}

function bundle_libyaml() {
  if [ "X$LINK_libyaml" == "X" ]; then
     echo "skipping libyaml, added in qgis_deps-0.8.0"
  else
    try cp -av $DEPS_LIB_DIR/libyaml*dylib $BUNDLE_LIB_DIR
  fi
}

function fix_binaries_libyaml() {
  if [ "X$LINK_libyaml" == "X" ]; then
     echo "skipping libyaml, added in qgis_deps-0.8.0"
  else
    install_name_id  @rpath/$LINK_libyaml $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libyaml
  fi
}

function fix_binaries_libyaml_check() {
  if [ "X$LINK_libyaml" == "X" ]; then
     echo "skipping libyaml, added in qgis_deps-0.8.0"
  else
    verify_binary $BUNDLE_LIB_DIR/$LINK_libyaml
  fi
}

function fix_paths_libyaml() {
  :
}

function fix_paths_libyaml_check() {
  :
}