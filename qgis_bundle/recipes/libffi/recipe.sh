#!/bin/bash

function check_libffi() {
  env_var_exists VERSION_libffi
}

function bundle_libffi() {
    : # install_name_tool -id "@rpath/liblibffi.dylib" ${STAGE_PATH}/lib/liblibffi.dylib
}

function postbundle_libffi() {
    :
}

function add_config_info_libffi() {
    :
}

patch_libffi_linker_links () {
  install_name_tool -id "@rpath/libffi.dylib" ${STAGE_PATH}/lib/libffi.dylib
}
