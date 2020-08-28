#!/bin/bash

function check_python_patsy() {
  env_var_exists VERSION_python_patsy
}

function bundle_python_patsy() {
  # the patsy.egg is zip file, unzip it to be able to fix binaries
  cd $BUNDLE_PYTHON_SITE_PACKAGES_DIR

  try unzip patsy-${VERSION_python_patsy}-py${VERSION_major_python}.egg -d _tmp_patsy
  try rm -rf patsy-${VERSION_python_patsy}-py${VERSION_major_python}.egg
  try mv _tmp_patsy patsy-${VERSION_python_patsy}-py${VERSION_major_python}.egg
}

function fix_binaries_python_patsy() {
  :
}

function fix_binaries_python_patsy_check() {
  :
}

function fix_paths_python_patsy() {
  :
}

function fix_paths_python_patsy_check() {
  :
}