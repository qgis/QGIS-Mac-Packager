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

function fix_binaries_python() {
  install_name_id @rpath/$LINK_python $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_python

  install_name_change $DEPS_LIB_DIR/$LINK_python @rpath/$LINK_python $BUNDLE_BIN_DIR/python$VERSION_major_python
  install_name_change $DEPS_LIB_DIR/$LINK_python @rpath/$LINK_python $BUNDLE_BIN_DIR/python$VERSION_major_python
  install_name_change $DEPS_LIB_DIR/$LINK_libintl @rpath/$LINK_libintl $BUNDLE_BIN_DIR/python$VERSION_major_python

  install_name_add_rpath @executable_path/lib $BUNDLE_BIN_DIR/python$VERSION_major_python
  install_name_add_rpath @executable_path/../lib $BUNDLE_BIN_DIR/python$VERSION_major_python

  install_name_change $DEPS_LIB_DIR/$LINK_libintl @rpath/$LINK_libintl $BUNDLE_LIB_DIR/libpython${VERSION_major_python}m.dylib

  install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_bz2.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_expat @rpath/$LINK_expat $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/pyexpat.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_expat @rpath/$LINK_expat $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_elementtree.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_ssl.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_hashlib.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_ssl.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_hashlib.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_sqlite @rpath/$LINK_sqlite $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_sqlite3.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_liblzma @rpath/$LINK_liblzma $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_lzma.cpython-37m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/zlib.cpython-37m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/binascii.cpython-37m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libffi @rpath/$LINK_libffi $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_ctypes.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_binaries_python_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_python
  verify_binary $BUNDLE_BIN_DIR/python$VERSION_major_python
  verify_binary $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/_elementtree.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python() {
    # patch shell scripts
    for i in \
      pip \
      pip3 \
      pip${VERSION_major_python} \
      python${VERSION_major_python}-config \
      python${VERSION_major_python}m-config
    do
      fix_exec_link $QGIS_DEPS_STAGE_PATH/bin/python3 python3 $BUNDLE_BIN_DIR/$i
    done
}

function fix_paths_python_check() {
  verify_file_paths $BUNDLE_BIN_DIR/pip3
}