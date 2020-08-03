#!/bin/bash

function check_openblas() {
  env_var_exists VERSION_openblas
  env_var_exists LINK_libopenblas
}

function bundle_openblas() {
  try cp -av $DEPS_LIB_DIR/libopenblas*dylib $BUNDLE_LIB_DIR
}

function postbundle_openblas() {
 install_name_id  @rpath/$LINK_libopenblas $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libopenblas
 install_name_id  @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libopenblas_haswellp

 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas @rpath/$LINK_libopenblas $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libopenblas_haswellp

 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy/core/_multiarray_umath.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy/linalg/lapack_lite.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy/linalg/_umath_linalg.cpython-${VERSION_major_python//./}m-darwin.so

 # TODO https://github.com/qgis/QGIS-Mac-Packager/issues/61
 NUMPY_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/numpy-${VERSION_python_numpy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $NUMPY_EGG_DIR/numpy/core/_multiarray_umath.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $NUMPY_EGG_DIR/numpy/linalg/lapack_lite.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $NUMPY_EGG_DIR/numpy/linalg/_umath_linalg.cpython-${VERSION_major_python//./}m-darwin.so

 SCIPY_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/scipy-${VERSION_python_scipy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/odr/__odrpack.cpython-${VERSION_major_python//./}m-darwin.so

 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/_decomp_update.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/_fblas.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/_flapack.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/_flinalg.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/_interpolative.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/_solve_toeplitz.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/cython_blas.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/linalg/cython_lapack.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/optimize/_trlib/_trlib.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/optimize/_lbfgsb.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/integrate/_odepack.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/integrate/_test_odeint_banded.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/integrate/lsoda.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/integrate/lsoda.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/integrate/vode.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/integrate/_quadpack.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/special/cython_special.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/special/_ufuncs.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/special/_ellip_harm_2.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/sparse/linalg/isolve/_iterative.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/sparse/linalg/eigen/arpack/_arpack.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/sparse/linalg/dsolve/_superlu.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas_haswellp @rpath/$LINK_libopenblas_haswellp $SCIPY_EGG_DIR/scipy/spatial/qhull.cpython-${VERSION_major_python//./}m-darwin.so
}
