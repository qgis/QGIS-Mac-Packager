#!/bin/bash

function check_python_scipy() {
  env_var_exists VERSION_python_scipy
}

function bundle_python_scipy() {
  :
}

function postbundle_python_scipy() {
 SCIPY_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/scipy-${VERSION_python_scipy}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
 for i in odr/__odrpack.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/_decomp_update.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/_fblas.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/_flapack.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/_flinalg.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/_interpolative.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/_solve_toeplitz.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/cython_blas.cpython-${VERSION_major_python//./}m-darwin.so \
          linalg/cython_lapack.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/__nnls.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_bglu_dense.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_cobyla.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_group_columns.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_lbfgsb.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_lsap_module.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_minpack.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_slsqp.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/_zeros.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/minpack2.cpython-${VERSION_major_python//./}m-darwin.so \
          optimize/moduleTNC.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/_dop.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/_odepack.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/_quadpack.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/_test_multivariate.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/_test_odeint_banded.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/lsoda.cpython-${VERSION_major_python//./}m-darwin.so \
          integrate/vode.cpython-${VERSION_major_python//./}m-darwin.so \
          io/_test_fortran.cpython-${VERSION_major_python//./}m-darwin.so \
          special/cython_special.cpython-${VERSION_major_python//./}m-darwin.so \
          special/_ufuncs.cpython-${VERSION_major_python//./}m-darwin.so \
          special/specfun.cpython-${VERSION_major_python//./}m-darwin.so \
          interpolate/dfitpack.cpython-${VERSION_major_python//./}m-darwin.so \
          interpolate/_fitpack.cpython-${VERSION_major_python//./}m-darwin.so \
          sparse/linalg/isolve/_iterative.cpython-${VERSION_major_python//./}m-darwin.so \
          sparse/linalg/eigen/arpack/_arpack.cpython-${VERSION_major_python//./}m-darwin.so \
          sparse/linalg/dsolve/_superlu.cpython-${VERSION_major_python//./}m-darwin.so \
          stats/statlib.cpython-${VERSION_major_python//./}m-darwin.so \
          stats/mvn.cpython-${VERSION_major_python//./}m-darwin.so
  do
    install_name_change $DEPS_LIB_DIR/$LINK_libquadmath @rpath/$LINK_libquadmath $SCIPY_EGG_DIR/scipy/$i
    install_name_change $DEPS_LIB_DIR/$LINK_libgfortran @rpath/$LINK_libgfortran $SCIPY_EGG_DIR/scipy/$i
    install_name_change $DEPS_LIB_DIR/$LINK_gcc_s @rpath/$LINK_gcc_s $SCIPY_EGG_DIR/scipy/$i
  done

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

