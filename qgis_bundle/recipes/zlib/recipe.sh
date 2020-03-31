#!/bin/bash

function check_zlib() {
  env_var_exists VERSION_zlib
}

function bundle_zlib() {
    : # install_name_tool -id "@rpath/libzlib.dylib" ${STAGE_PATH}/lib/libzlib.dylib
}

function postbundle_zlib() {
    :
}

function add_config_info_zlib() {
    :
}

patch_zlib_linker_links () {
  install_name_tool -id "@rpath/libz.${LINK_zlib_version}.dylib" ${STAGE_PATH}/lib/libz.${LINK_zlib_version}.dylib
}
