#!/bin/bash

function check_python_cftime() {
  env_var_exists VERSION_python_cftime
}

function bundle_python_cftime() {
  :
}

function fix_binaries_python_cftime() {
  :
}

function fix_binaries_python_cftime_check() {
  :
}

function fix_paths_python_cftime() {
  CFTIME_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/cftime-${VERSION_python_cftime}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
  clean_path $CFTIME_EGG/EGG-INFO/SOURCES.txt
}

function fix_paths_python_cftime_check() {
  :
}