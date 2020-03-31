#!/bin/bash

function check_qgis() {
  env_var_exists VERSION_qgis
}

function bundle_qgis() {
    : # install_name_tool -id "@rpath/libqgis.dylib" ${STAGE_PATH}/lib/libqgis.dylib
}

function postbundle_qgis() {
    :
}

function add_config_info_qgis() {
    :
}
