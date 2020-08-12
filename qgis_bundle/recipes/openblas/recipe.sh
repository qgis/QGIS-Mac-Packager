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

 install_name_change $DEPS_LIB_DIR/$LINK_libquadmath @rpath/$LINK_libquadmath $DEPS_LIB_DIR/$LINK_libopenblas_haswellp
 install_name_change $DEPS_LIB_DIR/$LINK_libgfortran @rpath/$LINK_libgfortran $DEPS_LIB_DIR/$LINK_libopenblas_haswellp
 install_name_change $DEPS_LIB_DIR/$LINK_gcc_s @rpath/$LINK_gcc_s $DEPS_LIB_DIR/$LINK_libopenblas_haswellp
}
