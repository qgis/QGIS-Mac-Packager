#!/bin/bash

function check_qscintilla() {
  env_var_exists VERSION_qscintilla
}

function bundle_qscintilla() {
    : # install_name_tool -id "@rpath/libqscintilla.dylib" ${STAGE_PATH}/lib/libqscintilla.dylib
}

function postbundle_qscintilla() {
    :
}

function add_config_info_qscintilla() {
    :
}