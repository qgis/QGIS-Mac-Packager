#!/bin/bash

function check_qtkeychain() {
  env_var_exists VERSION_qtkeychain
}

function bundle_qtkeychain() {
    : # install_name_tool -id "@rpath/libqtkeychain.dylib" ${STAGE_PATH}/lib/libqtkeychain.dylib
}

function postbundle_qtkeychain() {
    :
}

function add_config_info_qtkeychain() {
    :
}