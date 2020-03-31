#!/bin/bash

function check_openssl() {
  env_var_exists VERSION_openssl
}

function bundle_openssl() {
    : # install_name_tool -id "@rpath/libopenssl.dylib" ${STAGE_PATH}/lib/libopenssl.dylib
}

function postbundle_openssl() {
    :
}

function add_config_info_openssl() {
    :
}

patch_openssl_linker_links () {
  install_name_tool -id "@rpath/libssl.dylib" ${STAGE_PATH}/lib/libssl.dylib
  install_name_tool -id "@rpath/libcrypto.dylib" ${STAGE_PATH}/lib/libcrypto.dylib

  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libssl.${LINK_libssl_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libssl.${LINK_libssl_version}.dylib does not exist... maybe you updated the openssl version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libcrypto.${LINK_libcrypto_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libcrypto.${LINK_libcrypto_version}.dylib does not exist... maybe you updated the openssl version?"
  fi

  targets=(
    lib/libssl.dylib
    lib/engines-${LINK_libssl_version}/capi.dylib
    lib/engines-${LINK_libssl_version}/padlock.dylib
    bin/openssl
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libssl.${LINK_libssl_version}.dylib" "@rpath/libssl.${LINK_libssl_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libcrypto.${LINK_libcrypto_version}.dylib" "@rpath/libcrypto.${LINK_libcrypto_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}
