#!/bin/bash

function check_libtiff() {
  env_var_exists VERSION_libtiff
}

function bundle_libtiff() {
    : # install_name_tool -id "@rpath/liblibtiff.dylib" ${STAGE_PATH}/lib/liblibtiff.dylib
}

function postbundle_libtiff() {
    :
}

function add_config_info_libtiff() {
    :
}

patch_libtiff_linker_links () {
  install_name_tool -id "@rpath/libtiff.dylib" ${STAGE_PATH}/lib/libtiff.dylib
  install_name_tool -id "@rpath/libtiffxx.dylib" ${STAGE_PATH}/lib/libtiffxx.dylib

  if [ ! -f "${STAGE_PATH}/lib/libtiff.${LINK_libtiff_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libtiff.${LINK_libtiff_version}.dylib does not exist... maybe you updated the tiff version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libtiff.${LINK_libtiff_version}.dylib" "@rpath/libtiff.${LINK_libtiff_version}.dylib" ${STAGE_PATH}/lib/libtiffxx.dylib

  targets=(
    bin/tiff2bw
    bin/tiff2pdf
    bin/tiff2ps
    bin/tiff2rgba
    bin/tiffcmp
    bin/tiffcp
    bin/tiffcrop
    bin/tiffdither
    bin/tiffdump
    bin/tiffinfo
    bin/tiffmedian
    bin/tiffset
    bin/tiffsplit
    bin/fax2tiff
    bin/pal2rgb
    bin/fax2ps
    bin/raw2tiff
    bin/ppm2tiff
    bin/raw2tiff
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libtiff.${LINK_libtiff_version}.dylib" "@rpath/libtiff${LINK_libtiff_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
