#!/bin/bash

function check_netcdf() {
  env_var_exists VERSION_netcdf
}

function bundle_netcdf() {
    : # install_name_tool -id "@rpath/libnetcdf.dylib" ${STAGE_PATH}/lib/libnetcdf.dylib
}

function postbundle_netcdf() {
    :
}

function add_config_info_netcdf() {
    :
}

patch_nc_linker_links () {
  targets=(
    bin/nc-config
    bin/nccopy
    bin/ncdump
    bin/ncgen
    bin/ncgen3
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/netcdf/build-$ARCH/liblib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
