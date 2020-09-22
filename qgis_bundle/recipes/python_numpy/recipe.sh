#!/bin/bash

function check_python_numpy() {
  env_var_exists VERSION_python_numpy
}

function bundle_python_numpy() {
  :
}

function fix_binaries_python_numpy() {
  NUMPY_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/numpy-${VERSION_python_numpy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    core/_multiarray_umath \
    linalg/lapack_lite \
    linalg/_umath_linalg
  do
    install_name_change $DEPS_LIB_DIR/$LINK_libopenblas @rpath/$LINK_libopenblas $NUMPY_EGG_DIR/numpy/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_numpy_check() {
  NUMPY_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/numpy-${VERSION_python_numpy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  verify_binary $NUMPY_EGG_DIR/numpy/core/_multiarray_umath.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_numpy() {
  NUMPY_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/numpy-${VERSION_python_numpy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  clean_path $NUMPY_EGG_DIR/numpy/distutils/__config__.py
  clean_path $NUMPY_EGG_DIR/numpy/__config__.py
  clean_path $NUMPY_EGG_DIR/numpy/distutils/system_info.py
}

function fix_paths_python_numpy_check() {
  NUMPY_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/numpy-${VERSION_python_numpy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  verify_file_paths $NUMPY_EGG_DIR/numpy/distutils/__config__.py
}