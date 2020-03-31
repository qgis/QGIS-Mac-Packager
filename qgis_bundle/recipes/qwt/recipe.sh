#!/bin/bash

function check_qwt() {
  env_var_exists VERSION_qwt
}

function bundle_qwt() {
    : # install_name_tool -id "@rpath/libqwt.dylib" ${STAGE_PATH}/lib/libqwt.dylib
}

function postbundle_qwt() {
    :
}

function add_config_info_qwt() {
    :
}