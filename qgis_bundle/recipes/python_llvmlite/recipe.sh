#!/bin/bash

function check_python_$llvmlite() {
  env_var_exists VERSION_python_$llvmlite
}

function bundle_python_$llvmlite() {
  :
}

function postbundle_python_$llvmlite() {
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/llvmlite/binding/libllvmlite.dylib
}

