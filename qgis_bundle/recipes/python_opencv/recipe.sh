#!/bin/bash

function check_python_opencv() {
  env_var_exists VERSION_python_opencv
}

function bundle_python_opencv() {
  :
}

function fix_binaries_python_opencv() {
  OPENCV_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/opencv_contrib_python-${VERSION_python_opencv}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    $LINK_jpeg \
    $LINK_libwebp \
    $LINK_libpng \
    $LINK_libtiff \
    $LINK_protobuf \
    $LINK_zlib \
    $LINK_libopenblas \
    $LINK_libhdf5 \
    $LINK_openjpeg
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $OPENCV_EGG_DIR/cv2/cv2.cpython-37m-darwin.so
  done
}

function fix_binaries_python_opencv_check() {
  OPENCV_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/opencv_contrib_python-${VERSION_python_opencv}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  verify_binary $OPENCV_EGG_DIR/cv2/cv2.cpython-37m-darwin.so
}

function fix_paths_python_opencv() {
  :
}

function fix_paths_python_opencv_check() {
  :
}