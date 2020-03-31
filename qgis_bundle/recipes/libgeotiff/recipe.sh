#!/bin/bash

function check_libgeotiff() {
  env_var_exists VERSION_libgeodiff
}

function bundle_libgeotiff() {
    : # install_name_tool -id "@rpath/liblibgeodiff.dylib" ${STAGE_PATH}/lib/liblibgeodiff.dylib
}

function postbundle_libgeotiff() {
    :
}

function add_config_info_libgeotiff() {
    :
}

patch_libgeotiff_linker_links () {
  targets=(
    bin/listgeo
    bin/geotifcp
    bin/makegeo
    bin/applygeo
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/libgeotiff/build-$ARCH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
