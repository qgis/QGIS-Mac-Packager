#!/bin/bash

function check_spatialindex() {
  env_var_exists VERSION_spatialindex
}

function bundle_spatialindex() {
    : # install_name_tool -id "@rpath/libspatialindex.dylib" ${STAGE_PATH}/lib/libspatialindex.dylib
}

function postbundle_spatialindex() {
    :
}

function add_config_info_spatialindex() {
    :
}