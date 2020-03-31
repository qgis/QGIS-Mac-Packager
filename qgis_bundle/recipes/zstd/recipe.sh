#!/bin/bash

function check_zstd() {
  env_var_exists VERSION_zstd
}

function bundle_zstd() {
    : # install_name_tool -id "@rpath/libzstd.dylib" ${STAGE_PATH}/lib/libzstd.dylib
}

function postbundle_zstd() {
    :
}

function add_config_info_zstd() {
    :
}

patch_zstd_linker_links () {
  install_name_tool -id "@rpath/libzstd.dylib" ${STAGE_PATH}/lib/libzstd.dylib

  targets=(
    bin/zstd
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
