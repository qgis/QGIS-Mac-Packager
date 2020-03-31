#!/bin/bash

function check_png() {
  env_var_exists VERSION_png
}

function bundle_png() {
    : # install_name_tool -id "@rpath/libpng.dylib" ${STAGE_PATH}/lib/libpng.dylib
}

function postbundle_png() {
    :
}

function add_config_info_png() {
    :
}

patch_png_linker_links () {
  # install_name_tool -id "@rpath/libpng.dylib" ${STAGE_PATH}/lib/libpng.dylib

  if [ ! -f "${STAGE_PATH}/lib/libpng${LINK_libpng_version}.${LINK_libpng_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libpng${LINK_libpng_version}.${LINK_libpng_version}.dylib does not exist... maybe you updated the png version?"
  fi


  install_name_tool -id "@rpath/libpng${LINK_libpng_version}.${LINK_libpng_version}.dylib" ${STAGE_PATH}/lib/libpng${LINK_libpng_version}.${LINK_libpng_version}.dylib

  targets=(
    bin/png-fix-itxt
    bin/pngfix
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libpng${LINK_libpng_version}.${LINK_libpng_version}.dylib" "@rpath/libpng${LINK_libpng_version}.${LINK_libpng_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
