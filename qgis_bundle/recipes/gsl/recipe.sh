#!/bin/bash

function check_gsl() {
  env_var_exists VERSION_gsl
}

function bundle_gsl() {
    : # install_name_tool -id "@rpath/libgsl.dylib" ${STAGE_PATH}/lib/libgsl.dylib
}

function postbundle_gsl() {
    :
}

function add_config_info_gsl() {
    :
}
patch_gsl_linker_links () {
  install_name_tool -id "@rpath/libgsl.dylib" ${STAGE_PATH}/lib/libgsl.dylib
  install_name_tool -id "@rpath/libgslcblas.dylib" ${STAGE_PATH}/lib/libgslcblas.dylib

  if [ ! -f "${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib does not exist... maybe you updated the gsl version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib does not exist... maybe you updated the gsl version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib" "@rpath/libgsl.${LINK_libgsl_version}.dylib" ${STAGE_PATH}/bin/gsl-histogram
  install_name_tool -change "${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib" "@rpath/libgslcblas.${LINK_libgslcblas_version}.dylib" ${STAGE_PATH}/bin/gsl-histogram
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/gsl-histogram

  install_name_tool -change "${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib" "@rpath/libgsl.${LINK_libgsl_version}.dylib" ${STAGE_PATH}/bin/gsl-randist
  install_name_tool -change "${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib" "@rpath/libgslcblas.${LINK_libgslcblas_version}.dylib" ${STAGE_PATH}/bin/gsl-randist
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/gsl-randist
}
