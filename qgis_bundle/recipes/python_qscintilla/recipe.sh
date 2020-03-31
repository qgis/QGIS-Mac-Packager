#!/bin/bash

function check_python_qscintilla() {
  env_var_exists VERSION_python_qscintilla
}

function bundle_python_qscintilla() {
    : # install_name_tool -id "@rpath/libpython_qscintilla.dylib" ${STAGE_PATH}/lib/libpython_qscintilla.dylib
}

function postbundle_python_qscintilla() {
    :
}

function add_config_info_python_qscintilla() {
    :
}

patch_qscintilla_linker_links () {
  targets=(
    $QGIS_SITE_PACKAGES_PATH/PyQt5/Qsci.so
  )

  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @loader_path/../../../ $i
  done
}
