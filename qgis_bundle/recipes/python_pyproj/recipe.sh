#!/bin/bash

function check_python_pyproj() {
  env_var_exists VERSION_python_pyproj
}

function bundle_python_pyproj() {
  :
}

function postbundle_python_pyproj() {
  PYPROJ_EGG=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-${VERSION_python_pyproj}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/_list.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/_datadir.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/_crs.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/_geod.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/_proj.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $PYPROJ_EGG/pyproj/_transformer.cpython-${VERSION_major_python//./}m-darwin.so

}

