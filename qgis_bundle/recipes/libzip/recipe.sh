#!/bin/bash

function check_libzip() {
  env_var_exists VERSION_libzip
}

function bundle_libzip() {
    : # install_name_tool -id "@rpath/liblibzip.dylib" ${STAGE_PATH}/lib/liblibzip.dylib
}

function postbundle_libzip() {
    :
}

function add_config_info_libzip() {
    :
}

patch_zip_linker_links () {
  targets=(
    bin/zipcmp
    bin/zipmerge
    bin/ziptool
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/libzip/build-$ARCH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
