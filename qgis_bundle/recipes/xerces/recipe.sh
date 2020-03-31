#!/bin/bash

function check_xerces() {
  env_var_exists VERSION_xerces
}

function bundle_xerces() {
    : # install_name_tool -id "@rpath/libxerces.dylib" ${STAGE_PATH}/lib/libxerces.dylib
}

function postbundle_xerces() {
    :
}

function add_config_info_xerces() {
    :
}

patch_xerces_linker_links () {
  targets=(
    bin/XInclude
    bin/SAX2Print
    bin/CreateDOMDocument
    bin/StdInParse
    bin/PParse
    bin/SAX2Count
    bin/EnumVal
    bin/DOMCount
    bin/DOMPrint
    bin/MemParse
    bin/PSVIWriter
    bin/SAXCount
    bin/SEnumVal
    bin/SCMPrint
    bin/Redirect
    bin/SAXPrint
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/xerces/build-$ARCH/src ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
