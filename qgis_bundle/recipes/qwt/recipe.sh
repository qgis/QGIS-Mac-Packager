#!/bin/bash

function check_qwt() {
  env_var_exists VERSION_qwt
}

function bundle_qwt() {
  try rsync -av $DEPS_LIB_DIR/qwt.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers

   # install_name_tool -id "@rpath/libqwt.dylib" ${STAGE_PATH}/lib/libqwt.dylib
}

function postbundle_qwt() {
    :
}

function add_config_info_qwt() {
    :
}
