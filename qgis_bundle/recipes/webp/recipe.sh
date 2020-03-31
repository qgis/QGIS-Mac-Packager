#!/bin/bash

function check_webp() {
  env_var_exists VERSION_webp
}

function bundle_webp() {
    : # install_name_tool -id "@rpath/libwebp.dylib" ${STAGE_PATH}/lib/libwebp.dylib
}

function postbundle_webp() {
    :
}

function add_config_info_webp() {
    :
}

patch_webp_linker_links () {
  if [ ! -f "${STAGE_PATH}/lib/libwebp.${LINK_libwebp_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libwebp.${LINK_libwebp_version}.dylib does not exist... maybe you updated the webp version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libwebpdemux.${LINK_libwebpdemux_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libwebpdemux.${LINK_libwebpdemux_version}.dylib does not exist... maybe you updated the webp version?"
  fi

  install_name_tool -id "@rpath/libwebp.${LINK_libwebp_version}.dylib" ${STAGE_PATH}/lib/libwebp.${LINK_libwebp_version}.dylib
  install_name_tool -id "@rpath/libwebpdemux.${LINK_libwebpdemux_version}.dylib" ${STAGE_PATH}/lib/libwebpdemux.${LINK_libwebpdemux_version}.dylib

  install_name_tool -change "${STAGE_PATH}/lib/libwebp.${LINK_libwebp_version}.dylib" "@rpath/libwebp.${LINK_libwebp_version}.dylib" ${STAGE_PATH}/lib/libwebpdemux.dylib

  targets=(
    bin/dwebp
    bin/cwebp
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libwebp.${LINK_libwebp_version}.dylib" "@rpath/libwebp.${LINK_libwebp_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -change "${STAGE_PATH}/lib/libwebpdemux.${LINK_libwebpdemux_version}.dylib" "@rpath/libwebpdemux.${LINK_libwebpdemux_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
