#!/bin/bash

function check_freexl() {
  env_var_exists VERSION_freexl
}

function bundle_freexl() {
    : # install_name_tool -id "@rpath/libfreexl.dylib" ${STAGE_PATH}/lib/libfreexl.dylib
}

function postbundle_freexl() {
    :
}

function add_config_info_freexl() {
    :
}
