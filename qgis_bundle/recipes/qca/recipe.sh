#!/bin/bash

function check_qca() {
  env_var_exists VERSION_qca
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_qca() {
  try rsync -av $DEPS_LIB_DIR/$LINK_qca.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Header

  #### PLUGINS
  try rsync -av $DEPS_ROOT_DIR/qt5/plugins/crypto $BUNDLE_PLUGINS_DIR/
}

function fix_binaries_qca() {
  install_name_id @rpath/$LINK_qca.framework/Versions/${VERSION_qca}/$LINK_qca $BUNDLE_CONTENTS_DIR/Frameworks/$LINK_qca.framework/Versions/${VERSION_qca}/$LINK_qca

  for i in \
    libqca-cyrus-sasl \
    libqca-logger \
    libqca-ossl \
    libqca-softstore
  do
    install_name_change $DEPS_LIB_DIR/$LINK_qca.framework/Versions/${VERSION_qca}/$LINK_qca @rpath/$LINK_qca.framework/Versions/${VERSION_qca}/$LINK_qca $BUNDLE_PLUGINS_DIR/crypto/$i.dylib
  done

  for i in \
    $LINK_libssl \
    $LINK_libcrypto
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_CONTENTS_DIR/PlugIns/crypto/libqca-ossl.dylib
  done
}

function fix_binaries_qca_check() {
  verify_binary $BUNDLE_CONTENTS_DIR/PlugIns/crypto/libqca-ossl.dylib
}

function fix_paths_qca() {
  :
}

function fix_paths_qca_check() {
  :
}