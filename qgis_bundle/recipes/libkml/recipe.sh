#!/bin/bash

function check_libkml() {
  env_var_exists VERSION_libkml
  env_var_exists LINK_libkmlbase
}

function bundle_libkml() {
  try cp -av $DEPS_LIB_DIR/libkml*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libkml() {
  for i in \
    $LINK_libkmlbase \
    $LINK_libkmlconvenience \
    $LINK_libkmldom \
    $LINK_libkmlengine \
    $LINK_libkmlregionator \
    $LINK_libkmlxsd
  do
    install_name_id @rpath/$i $BUNDLE_LIB_DIR/$i
    for j in \
        $LINK_libkmlbase \
        $LINK_libkmlconvenience \
        $LINK_libkmldom \
        $LINK_libkmlengine \
        $LINK_libkmlregionator \
        $LINK_libkmlxsd \
        $LINK_libminizip \
        $LINK_expat \
        $LINK_liburiparser \
        $LINK_zlib
    do
      install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_LIB_DIR/$i
    done
  done
}

function fix_binaries_libkml_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libkmlbase
}

function fix_paths_libkml() {
  :
}

function fix_paths_libkml_check() {
  :
}
