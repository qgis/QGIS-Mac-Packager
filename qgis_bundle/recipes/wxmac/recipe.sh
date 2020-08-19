#!/bin/bash

function check_wxmac() {
  env_var_exists VERSION_wxmac
  env_var_exists VERSION_wxmac_major
}

function bundle_wxmac() {
  try cp -av $DEPS_LIB_DIR/libwx_*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_wxmac() {
  for i in \
    libwx_baseu_xml \
    libwx_baseu_net \
    libwx_osx_cocoau_gl \
    libwx_osx_cocoau_aui \
    libwx_baseu \
    libwx_osx_cocoau_qa \
    libwx_osx_cocoau_xrc \
    libwx_osx_cocoau_stc \
    libwx_osx_cocoau_ribbon \
    libwx_osx_cocoau_core \
    libwx_osx_cocoau_adv \
    libwx_osx_cocoau_html \
    libwx_osx_cocoau_propgrid \
    libwx_osx_cocoau_richtext \
    libwx_osx_cocoau_media
  do
    install_name_id @rpath/$i-${LINK_wxmac_version}.dylib $BUNDLE_LIB_DIR/$i-${LINK_wxmac_version}.dylib

    for j in \
      $LINK_zlib \
      $LINK_libpng \
      $LINK_jpeg \
      $LINK_libtiff \
      $LINK_expat \
      libwx_baseu_xml-${LINK_wxmac_version}.dylib \
      libwx_baseu_net-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib \
      libwx_baseu-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib \
      libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib
    do
      install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_LIB_DIR/$i-${LINK_wxmac_version}.dylib
    done
  done
}

function fix_binaries_wxmac_check() {
  verify_binary $BUNDLE_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib
}

function fix_paths_wxmac() {
  :
}

function fix_paths_wxmac_check() {
  :
}