#!/bin/bash

function check_sqlite() {
  env_var_exists VERSION_sqlite
}

function bundle_sqlite() {
    : # install_name_tool -id "@rpath/libsqlite.dylib" ${STAGE_PATH}/lib/libsqlite.dylib
}

function postbundle_sqlite() {
    :
}

function add_config_info_sqlite() {
    :
}

patch_sqlite_linker_links () {
  install_name_tool -id "@rpath/libsqlite3.dylib" ${STAGE_PATH}/lib/libsqlite3.dylib

  targets=(
    bin/sqlite3
  )

  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
