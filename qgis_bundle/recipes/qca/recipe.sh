#!/bin/bash

function check_qca() {
  env_var_exists VERSION_qca
}

function bundle_qca() {
    : # install_name_tool -id "@rpath/libqca.dylib" ${STAGE_PATH}/lib/libqca.dylib
}

function postbundle_qca() {
    :
}

function add_config_info_qca() {
    :
}

patch_qca_linker_links () {
  install_name_tool -id "@rpath/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5" ${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5

  targets=(
    bin/mozcerts-qt5
    bin/qcatool-qt5
  )

  for i in ${targets[*]}
  do
     install_name_tool -change "${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5" "@rpath/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5" ${STAGE_PATH}/$i
     install_name_tool -add_rpath $QT_BASE/clang_64/lib ${STAGE_PATH}/$i
  done
}
