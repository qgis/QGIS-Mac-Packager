#!/bin/bash

function check_libxml2() {
  env_var_exists VERSION_libxml2
}

function bundle_libxml2() {
    : # install_name_tool -id "@rpath/liblibxml2.dylib" ${STAGE_PATH}/lib/liblibxml2.dylib
}

function postbundle_libxml2() {
    :
}

function add_config_info_libxml2() {
    :
}

patch_libxml2_linker_links () {
  install_name_tool -id "@rpath/libxml2.dylib" ${STAGE_PATH}/lib/libxml2.dylib

  targets=(
    bin/xml2-config
    bin/xmlcatalog
    bin/xmllint
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libxml2.${LINK_libxml2_version}.dylib" "@rpath/libxml2.${LINK_libwebp_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
