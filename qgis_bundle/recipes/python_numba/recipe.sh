#!/bin/bash

numba_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/numba-${VERSION_python_numba}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

function check_python_numba() {
  env_var_exists VERSION_python_numba
}

function bundle_python_numba() {
  :
}

function fix_binaries_python_numba() {
  :
}

function fix_binaries_python_numba_check() {
  :
}

function fix_paths_python_numba() {
  try rm -rf $numba_EGG_DIR/EGG-INFO/scripts
}

function fix_paths_python_numba_check() {
  :
}