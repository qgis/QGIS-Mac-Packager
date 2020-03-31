#!/bin/bash

function check_spatialite() {
  env_var_exists VERSION_spatialite
}

function bundle_spatialite() {
    : # install_name_tool -id "@rpath/libspatialite.dylib" ${STAGE_PATH}/lib/libspatialite.dylib
}

function postbundle_spatialite() {
    :
}

function add_config_info_spatialite() {
    :
}
function patch_spatialite_linker_links() {
  install_name_tool -id "@rpath/libspatialite.dylib" ${STAGE_PATH}/lib/libspatialite.dylib

}
