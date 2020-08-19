#!/bin/bash

function check_libxslt() {
  env_var_exists VERSION_libxslt
  env_var_exists LINK_libxslt
  env_var_exists LINK_libexslt
}

function bundle_libxslt() {
  try cp -av $DEPS_LIB_DIR/libxslt.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libexslt.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libxslt() {
  install_name_id @rpath/$LINK_libxslt $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libxslt
  install_name_id @rpath/$LINK_libexslt $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libexslt

  for i in \
    $LINK_libxml2 \
    $LINK_zlib \
    $LINK_libxslt
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libxslt
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libexslt
  done
}

function fix_binaries_libxslt_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libxslt
  verify_binary $BUNDLE_LIB_DIR/$LINK_libexslt
}

function fix_paths_libxslt() {
  :
}

function fix_paths_libxslt_check() {
  :
}