#!/bin/bash

function check_openblas() {
  env_var_exists VERSION_openblas
  env_var_exists LINK_libopenblas
}

function bundle_openblas() {
  try cp -av $DEPS_LIB_DIR/libopenblas*dylib $BUNDLE_LIB_DIR

  /opt/QGIS/qgis-deps-0.5.1/stage/lib/libopenblas.0.dylib
/opt/QGIS/qgis-deps-0.5.1/stage/lib/libopenblas.a
/opt/QGIS/qgis-deps-0.5.1/stage/lib/libopenblas.dylib
/opt/QGIS/qgis-deps-0.5.1/stage/lib/libopenblas_haswellp-r0.3.10.a
/opt/QGIS/qgis-deps-0.5.1/stage/lib/libopenblas_haswellp-r0.3.10.dylib
}

function postbundle_openblas() {
 install_name_id  @rpath/$LINK_libopenblas $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libopenblas
 install_name_id  @rpath/$LINK_libopenblas_haswellp $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libopenblas_haswellp

 install_name_change $DEPS_LIB_DIR/$LINK_libopenblas @rpath/$LINK_libopenblas $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libopenblas_haswellp
}
