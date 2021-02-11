#!/bin/bash

function check_libicu() {
  env_var_exists VERSION_libicu
  env_var_exists LINK_libicudata
}

function bundle_libicu() {
  try cp -av $DEPS_LIB_DIR/libicudata.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicuuc.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicui18n.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicuio.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libicutu.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libicu() {
  targets=(
    $LINK_libicudata
    $LINK_libicuuc
    $LINK_libicui18n
    $LINK_libicuio
    $LINK_libicutu
  )
  for i in ${targets[*]}
  do
    try install_name_tool -id @rpath/$i $BUNDLE_LIB_DIR/$i
    for j in ${targets[*]}
    do
      try install_name_tool -change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_LIB_DIR/$i
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