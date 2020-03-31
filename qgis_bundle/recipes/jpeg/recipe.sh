#!/bin/bash

function check_jpeg() {
  env_var_exists VERSION_jpeg
}

function bundle_jpeg() {
    : # install_name_tool -id "@rpath/libjpeg.dylib" ${STAGE_PATH}/lib/libjpeg.dylib
}

function postbundle_jpeg() {
    :
}

function add_config_info_jpeg() {
    :
}

patch_jpeg_linker_links () {
  # install_name_tool -id "@rpath/libjpeg.dylib" ${STAGE_PATH}/lib/libjpeg.dylib

  if [ ! -f "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib does not exist... maybe you updated the jpeg version?"
  fi

  install_name_tool -id "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib

  install_name_tool -change "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/bin/cjpeg
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/cjpeg

  install_name_tool -change "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/bin/djpeg
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/djpeg

  install_name_tool -change "${STAGE_PATH}/lib/libjpeg.${LINK_jpeg_version}.dylib" "@rpath/libjpeg.${LINK_jpeg_version}.dylib" ${STAGE_PATH}/bin/jpegtran
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/jpegtran

  # this one does not link, do we need to rpath ?
  install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/bin/wrjpgcom
  install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/bin/rdjpgcom
}
