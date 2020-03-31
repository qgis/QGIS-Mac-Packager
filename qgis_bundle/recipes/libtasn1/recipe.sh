#!/bin/bash

function check_libtasn1() {
  env_var_exists VERSION_libtasn1
}

function bundle_libtasn1() {
    : # install_name_tool -id "@rpath/liblibtasn1.dylib" ${STAGE_PATH}/lib/liblibtasn1.dylib
}

function postbundle_libtasn1() {
    :
}

function add_config_info_libtasn1() {
    :
}

patch_tasn1_linker_links () {
  install_name_tool -id "@rpath/libtasn1.dylib" ${STAGE_PATH}/lib/libtasn1.dylib

  if [ ! -f "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib does not exist... maybe you updated the libtasn1 version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" "@rpath/libtasn1.${LINK_libtasn1_version}.dylib" ${STAGE_PATH}/bin/asn1Coding
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/asn1Coding

  install_name_tool -change "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" "@rpath/libtasn1.${LINK_libtasn1_version}.dylib" ${STAGE_PATH}/bin/asn1Decoding
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/asn1Decoding

  install_name_tool -change "${STAGE_PATH}/lib/libtasn1.${LINK_libtasn1_version}.dylib" "@rpath/libtasn1.${LINK_libtasn1_version}.dylib" ${STAGE_PATH}/bin/asn1Parser
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/asn1Parser
}
