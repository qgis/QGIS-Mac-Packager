#!/bin/bash

function check_protobuf() {
  env_var_exists VERSION_protobuf
}

function bundle_protobuf() {
    : # install_name_tool -id "@rpath/libprotobuf.dylib" ${STAGE_PATH}/lib/libprotobuf.dylib
}

function postbundle_protobuf() {
    :
}

function add_config_info_protobuf() {
    :
}

patch_protobuf_linker_links () {
  install_name_tool -id "@rpath/libprotobuf.dylib" ${STAGE_PATH}/lib/libprotobuf.dylib
  install_name_tool -id "@rpath/libprotobuf-lite.dylib" ${STAGE_PATH}/lib/libprotobuf-lite.dylib
  install_name_tool -id "@rpath/libprotoc.dylib" ${STAGE_PATH}/lib/libprotoc.dylib

  if [ ! -f "${STAGE_PATH}/lib/libprotobuf.${LINK_protobuf_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libprotobuf.${LINK_protobuf_version}.dylib does not exist... maybe you updated the protobuf version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libprotobuf.${LINK_protobuf_version}.dylib" "@rpath/libprotobuf.${LINK_protobuf_version}.dylib" ${STAGE_PATH}/lib/libprotoc.dylib

  targets=(
    bin/protoc
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libprotobuf.${LINK_protobuf_version}.dylib" "@rpath/libprotobuf.${LINK_protobuf_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -change "${STAGE_PATH}/lib/libprotoc.${LINK_protobuf_version}.dylib" "@rpath/libprotoc.${LINK_protobuf_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done

}
