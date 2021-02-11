#!/bin/bash

function check_python_packages() {
  env_var_exists DEPS_PYTHON_PACKAGES_DIR
  env_var_exists BUNDLE_PYTHON_PACKAGES_DIR
}

function bundle_python_packages() {
  try rsync -av \
     $DEPS_PYTHON_PACKAGES_DIR/ \
     $BUNDLE_PYTHON_PACKAGES_DIR/ \
     --exclude __pycache__

  mk_sym_link $BUNDLE_LIB_DIR ../../Resources/python python$VERSION_major_python

  # we do not need to ship python tests
  try rm -rf $BUNDLE_PYTHON_PACKAGES_DIR/test

  # we do not need to ship cmake, it is development tool
  try rm -rf $BUNDLE_PYTHON_PACKAGES_DIR/config-${VERSION_major_python}-darwin/python.o
  try rm $BUNDLE_PYTHON_PACKAGES_DIR/site-packages/setuptools.pth

  cd $BUNDLE_PYTHON_SITE_PACKAGES_DIR

  # see QGIS-Mac-Packager#87, *-info is sometimes required,
  # so we shouldn't delete it!

  ###############
  # CERTIFICATES
  # see https://github.com/qgis/QGIS/issues/37107
  # use certifi root certificates rather than openssl
  try mkdir -p $BUNDLE_RESOURCES_DIR/certs
  mk_sym_link $BUNDLE_RESOURCES_DIR/certs ../python/site-packages/certifi/cacert.pem certifi.pem
  mk_sym_link $BUNDLE_RESOURCES_DIR/certs certifi.pem certs.pem

  # issue #32
  # _ssl is already taken in lib-dynload
  try mv $BUNDLE_PYTHON_PACKAGES_DIR/ssl.py $BUNDLE_PYTHON_PACKAGES_DIR/_ssl2.py
  try cp -av $RECIPES_PATH/python_packages/ssl.py $BUNDLE_PYTHON_PACKAGES_DIR/ssl.py
}

function fix_binaries_python_packages() {
  install_name_change $QGIS_DEPS_STAGE_PATH/unixodbc/lib/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_PYTHON_SITE_PACKAGES_DIR/pyodbc.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  install_name_change $DEPS_LIB_DIR/$LINK_libffi @rpath/$LINK_libffi $BUNDLE_PYTHON_SITE_PACKAGES_DIR/_cffi_backend.cpython-${VERSION_major_python//./}m-darwin.so

  install_name_change $DEPS_LIB_DIR/$LINK_libffi @rpath/$LINK_libffi $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/etree.cpython-${VERSION_major_python//./}m-darwin.so

  for i in \
    $LINK_libxml2 \
    $LINK_zlib \
    $LINK_libxslt \
    $LINK_libexslt
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/etree.cpython-${VERSION_major_python//./}m-darwin.so
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/objectify.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_packages_check() {
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/pyodbc.cpython-${VERSION_major_python//./}m-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/_cffi_backend.cpython-${VERSION_major_python//./}m-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/etree.cpython-${VERSION_major_python//./}m-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/objectify.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_packages() {
  # patch shell scripts
  for i in \
      2to3 \
      2to3-${VERSION_major_python} \
      idle3 \
      idle${VERSION_major_python} \
      pyvenv \
      pyvenv-${VERSION_major_python} \
      pydoc3 \
      pydoc${VERSION_major_python} \
      pyrcc5 \
      pyuic5 \
      pylupdate5 \
      pipenv-resolver \
      pipenv
  do
    fix_exec_link $QGIS_DEPS_STAGE_PATH/bin/python3 python3 $BUNDLE_BIN_DIR/$i
  done

  clean_path $BUNDLE_PYTHON_PACKAGES_DIR/_sysconfigdata_m_darwin_darwin.py
  clean_path $BUNDLE_PYTHON_SITE_PACKAGES_DIR/sipconfig.py
}

function fix_paths_python_packages_check() {
  verify_file_paths $BUNDLE_BIN_DIR/pyrcc5
  verify_file_paths $BUNDLE_PYTHON_PACKAGES_DIR/_sysconfigdata_m_darwin_darwin.py
  verify_file_paths $BUNDLE_PYTHON_SITE_PACKAGES_DIR/sipconfig.py
}