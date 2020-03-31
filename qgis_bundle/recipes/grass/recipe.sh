#!/bin/bash

function check_grass() {
  env_var_exists VERSION_grass
}

function bundle_grass() {
    : # install_name_tool -id "@rpath/libgrass.dylib" ${STAGE_PATH}/lib/libgrass.dylib
}

function postbundle_grass() {
    :
}

function add_config_info_grass() {
    :
}
