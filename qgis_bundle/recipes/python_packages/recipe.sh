#!/bin/bash

function check_python_packages() {
  env_var_exists VERSION_python_packages
}

function bundle_python_packages() {
    : # install_name_tool -id "@rpath/libpython_packages.dylib" ${STAGE_PATH}/lib/libpython_packages.dylib
}

function postbundle_python_packages() {
    :
}

function add_config_info_python_packages() {
    :
}

patch_python_packages_linker_links () {
  targets=(
    $QGIS_SITE_PACKAGES_PATH/h5py/_errors.cpython-37m-darwin.so
  )

  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @loader_path/../../../ $i
  done
}
