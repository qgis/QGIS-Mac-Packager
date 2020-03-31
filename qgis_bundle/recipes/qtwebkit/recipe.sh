#!/bin/bash

function check_qtwebkit() {
  env_var_exists VERSION_qtwebkit
}

function bundle_qtwebkit() {
    : # install_name_tool -id "@rpath/libqtwebkit.dylib" ${STAGE_PATH}/lib/libqtwebkit.dylib
}

function postbundle_qtwebkit() {
    :
}

function add_config_info_qtwebkit() {
    :
}