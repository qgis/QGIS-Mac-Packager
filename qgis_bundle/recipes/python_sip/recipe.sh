#!/bin/bash

function check_python_sip() {
  env_var_exists VERSION_python_sip
}

function bundle_python_sip() {
    : # install_name_tool -id "@rpath/libpython_sip.dylib" ${STAGE_PATH}/lib/libpython_sip.dylib
}

function postbundle_python_sip() {
    :
}

function add_config_info_python_sip() {
    :
}