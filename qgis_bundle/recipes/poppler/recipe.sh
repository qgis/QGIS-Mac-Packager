#!/bin/bash

function check_poppler() {
  env_var_exists VERSION_poppler
  env_var_exists LINK_poppler
  env_var_exists LINK_poppler_cpp
  env_var_exists LINK_poppler_qt5
}

function bundle_poppler() {
  try cp -av $DEPS_LIB_DIR/libpoppler*dylib $BUNDLE_LIB_DIR/
}

function fix_binaries_poppler() {
  install_name_id @rpath/$LINK_poppler $BUNDLE_LIB_DIR/$LINK_poppler
  install_name_id @rpath/$LINK_poppler_cpp $BUNDLE_LIB_DIR/$LINK_poppler_cpp
  install_name_id @rpath/$LINK_poppler_qt5 $BUNDLE_LIB_DIR/$LINK_poppler_qt5

  for i in \
    $LINK_poppler \
    $LINK_poppler_cpp \
    $LINK_poppler_qt5
  do
    for j in \
      $LINK_poppler \
      $LINK_freetype \
      $LINK_fontconfig \
      $LINK_jpeg \
      $LINK_zlib \
      $LINK_openjpeg \
      $LINK_libpng \
      $LINK_libtiff \
      $LINK_little_cms2
    do
      install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_LIB_DIR/$i
    done
  done
}

function fix_binaries_poppler_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_poppler
  verify_binary $BUNDLE_LIB_DIR/$LINK_poppler_cpp
  verify_binary $BUNDLE_LIB_DIR/$LINK_poppler_qt5
}

function fix_paths_poppler() {
  :
}

function fix_paths_poppler_check() {
  :
}
