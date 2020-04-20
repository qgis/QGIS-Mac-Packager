#!/bin/bash

function check_qwt() {
  env_var_exists VERSION_qwt
}

function bundle_qwt() {
  try rsync -av $DEPS_LIB_DIR/qwt.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function postbundle_qwt() {
  install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Frameworks/qwt.framework/Versions/6/qwt
}

function add_config_info_qwt() {
    :
}
