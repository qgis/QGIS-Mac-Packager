#!/bin/bash

function check_python() {
  env_var_exists VERSION_python
}

function bundle_python() {
    try cp -av $DEPS_LIB_DIR/libpython*dylib $BUNDLE_LIB_DIR
    chmod 755 $BUNDLE_LIB_DIR/libpython*dylib

    try cp -av $DEPS_BIN_DIR/2to3* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/idle3* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/pydoc3* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/python* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/pyvenv* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/pyrcc5* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/pyuic5* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/pylupdate5* $BUNDLE_BIN_DIR/
    try cp -av $DEPS_BIN_DIR/pip* $BUNDLE_BIN_DIR/
}

function postbundle_python() {
    install_name_id @rpath/$LINK_python $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_python

    install_name_change $DEPS_LIB_DIR/$LINK_python @rpath/$LINK_python $BUNDLE_BIN_DIR/python$VERSION_major_python
    install_name_change $DEPS_LIB_DIR/$LINK_python @rpath/$LINK_python $BUNDLE_BIN_DIR/python$VERSION_major_python

    install_name_add_rpath @executable_path/lib $BUNDLE_BIN_DIR/python$VERSION_major_python
    install_name_add_rpath @executable_path/../lib $BUNDLE_BIN_DIR/python$VERSION_major_python

    # patch shell scripts
    for i in pip pip3 pip3.7 2to3 2to3-3.7 idle3 idle3.7 pyvenv pyvenv-3.7 pydoc3 pydoc3.7 python3.7-config python3.7m-config pyrcc5 pyuic5 pylupdate5
    do
      fix_exec_link $QGIS_DEPS_STAGE_PATH/bin/python3 python3 $BUNDLE_BIN_DIR/$i
    done

    install_name_change $DEPS_LIB_DIR/$LINK_python @rpath/$LINK_python $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib
}
