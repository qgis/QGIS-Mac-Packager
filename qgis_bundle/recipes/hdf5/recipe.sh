#!/bin/bash

function check_hdf5() {
  env_var_exists VERSION_hdf5
}

function bundle_hdf5() {
    : # install_name_tool -id "@rpath/libhdf5.dylib" ${STAGE_PATH}/lib/libhdf5.dylib
}

function postbundle_hdf5() {
    :
}

function add_config_info_hdf5() {
    :
}

patch_hdf5_linker_links () {
  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libhdf5.${LINK_libhdf5_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libhdf5.${LINK_libhdf5_version}.dylib does not exist... maybe you updated the hdf5 version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libhdf5_cpp.100.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libhdf5_cpp.${LINK_libhdf5_version}.dylib does not exist... maybe you updated the hdf5 version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libhdf5_hl.100.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libhdf5_hl.${LINK_libhdf5_version}.dylib does not exist... maybe you updated the hdf5 version?"
  fi

  # these are bash scripts
  # bin/h5c++
  # bin/h5cc
  # bin/h5redeploy

  targets=(
    lib/libhdf5_hl.dylib
    lib/libhdf5_hl_cpp.dylib
    lib/libhdf5_cpp.dylib
    bin/gif2h5
    bin/h52gif

    bin/h5clear
    bin/h5copy
    bin/h5debug
    bin/h5diff
    bin/h5dump
    bin/h5format_convert
    bin/h5import
    bin/h5jam
    bin/h5ls
    bin/h5mkgrp
    bin/h5perf_serial

    bin/h5repack
    bin/h5repart
    bin/h5stat
    bin/h5unjam
    bin/h5watch
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libhdf5.${LINK_libhdf5_version}.dylib" "@rpath/libhdf5.${LINK_libhdf5_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libhdf5_cpp.${LINK_libhdf5_version}.dylib" "@rpath/libhdf5_cpp.${LINK_libhdf5_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libhdf5_hl.${LINK_libhdf5_version}.dylib" "@rpath/libhdf5_hl.${LINK_libhdf5_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}
