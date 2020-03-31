#!/bin/bash

function check_libxslt() {
  env_var_exists VERSION_libxslt
}

function bundle_libxslt() {
    : # install_name_tool -id "@rpath/liblibxslt.dylib" ${STAGE_PATH}/lib/liblibxslt.dylib
}

function postbundle_libxslt() {
    :
}

function add_config_info_libxslt() {
    :
}

patch_libxslt_linker_links () {
  install_name_tool -id "@rpath/libxslt.dylib" ${STAGE_PATH}/lib/libxslt.dylib
  install_name_tool -id "@rpath/libexslt.dylib" ${STAGE_PATH}/lib/libexslt.dylib

  if [ ! -f "${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib does not exist... maybe you updated the libxslt version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libexslt.${LINK_libexslt_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libexslt.${LINK_libexslt_version}.dylib does not exist... maybe you updated the libxslt version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib" "@rpath/libxslt.${LINK_libxslt_version}.dylib" ${STAGE_PATH}/lib/libexslt.dylib

  install_name_tool -change "${STAGE_PATH}/lib/libxslt.${LINK_libxslt_version}.dylib" "@rpath/libxslt.${LINK_libxslt_version}.dylib" ${STAGE_PATH}/bin/xsltproc
  install_name_tool -change "${STAGE_PATH}/lib/libexslt.${LINK_libexslt_version}.dylib" "@rpath/libexslt.${LINK_libexslt_version}.dylib" ${STAGE_PATH}/bin/xsltproc
  install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/bin/xsltproc
}
