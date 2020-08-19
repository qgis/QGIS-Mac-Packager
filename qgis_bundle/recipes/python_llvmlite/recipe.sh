#!/bin/bash

function check_python_llvmlite() {
  env_var_exists VERSION_python_$llvmlite
}

function bundle_python_llvmlite() {
  :
}

function fix_binaries_python_llvmlite() {
  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_PYTHON_SITE_PACKAGES_DIR/llvmlite/binding/libllvmlite.dylib
}


function fix_binaries_python_llvmlite_check() {
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/llvmlite/binding/libllvmlite.dylib
}

function fix_paths_python_llvmlite() {
  :
}

function fix_paths_python_llvmlite_check() {
  :
}