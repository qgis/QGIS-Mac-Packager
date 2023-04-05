#!/bin/bash

function check_qwt() {
  env_var_exists VERSION_qwt
}

function bundle_qwt() {
  try rsync -av $DEPS_LIB_DIR/qwt.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function fix_binaries_qwt() {
  install_name_delete_rpath $QT_BASE/lib $BUNDLE_FRAMEWORKS_DIR/qwt.framework/Versions/$VERSION_qwt_major/qwt
}

function fix_binaries_qwt_check() {
  verify_binary $BUNDLE_FRAMEWORKS_DIR/qwt.framework/Versions/$VERSION_qwt_major/qwt
}

function fix_paths_qwt() {
  :
}

function fix_paths_qwt_check() {
  :
}