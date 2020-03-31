#!/bin/bash

function check_geos() {
  env_var_exists VERSION_geos
}

function bundle_geos() {
    : # install_name_tool -id "@rpath/libgeos.dylib" ${STAGE_PATH}/lib/libgeos.dylib
}

function postbundle_geos() {
    :
}

function add_config_info_geos() {
    :
}
