#!/bin/bash

function check_python_numpy() {
  env_var_exists VERSION_python_numpy
}

function bundle_python_numpy() {
  :
}

function postbundle_python_numpy() {
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy/core/_multiarray_umath.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy/linalg/lapack_lite.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy/linalg/_umath_linalg.cpython-${VERSION_major_python//./}m-darwin.so

 # TODO https://github.com/qgis/QGIS-Mac-Packager/issues/61
 NUMPY_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy-${VERSION_python_numpy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $NUMPY_EGG_DIR/numpy/core/_multiarray_umath.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $NUMPY_EGG_DIR/numpy/linalg/lapack_lite.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $NUMPY_EGG_DIR/numpy/linalg/_umath_linalg.cpython-${VERSION_major_python//./}m-darwin.so
}

