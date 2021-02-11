#!/bin/bash

function check_libicu() {
  env_var_exists VERSION_libicu
  env_var_exists LINK_libicu
}

function bundle_libicu() {
  try cp -av $DEPS_LIB_DIR/libicudata.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicuuc.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicui18n.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicuio.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicutu.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libicu() {
  install_name_id  @rpath/$LINK_libicu $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libicu

  targets=(
    $LINK_libicudata
    $LINK_libicuuc
    $LINK_libicui18n
    $LINK_libicuio
    $LINK_libicutu
  )
  for i in ${targets[*]}
  do
    try install_name_tool -id $STAGE_PATH/lib/$i $STAGE_PATH/lib/$i
    for j in ${targets[*]}
    do
      try install_name_tool -change $j $STAGE_PATH/lib/$j $STAGE_PATH/lib/$i
    done
  done
}

function fix_binaries_libicu_check() {
    targets=(
    $LINK_libicudata
    $LINK_libicuuc
    $LINK_libicui18n
    $LINK_libicuio
    $LINK_libicutu
  )
  for i in ${targets[*]}
  do
    verify_binary $BUNDLE_LIB_DIR/$i
  done
}

function fix_paths_libicu() {
  :
}

function fix_paths_libicu_check() {
  :
}