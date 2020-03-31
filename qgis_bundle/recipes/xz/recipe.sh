#!/bin/bash

function check_xz() {
  env_var_exists VERSION_xz
}

function bundle_xz() {
    : # install_name_tool -id "@rpath/libxz.dylib" ${STAGE_PATH}/lib/libxz.dylib
}

function postbundle_xz() {
    :
}

function add_config_info_xz() {
    :
}

patch_xz_linker_links () {
  install_name_tool -id "@rpath/liblzma.dylib" ${STAGE_PATH}/lib/liblzma.dylib

  if [ ! -f "${STAGE_PATH}/lib/liblzma.${LINK_liblzma_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/liblzma.${LINK_liblzma_version}.dylib does not exist... maybe you updated the xz version?"
  fi

  targets=(
    bin/lzmainfo
    bin/xzdec
    bin/xz
    bin/lzmadec
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/liblzma.${LINK_liblzma_version}.dylib" "@rpath/liblzma.${LINK_liblzma_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
