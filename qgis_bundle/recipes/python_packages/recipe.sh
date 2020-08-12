#!/bin/bash

function check_python_packages() {
  env_var_exists VERSION_python_packages
  env_var_exists DEPS_PYTHON_SITE_PACKAGES_DIR
  env_var_exists BUNDLE_PYTHON_SITE_PACKAGES_DIR
}

function bundle_python_packages() {
   try rsync -av $DEPS_PYTHON_SITE_PACKAGES_DIR/ $BUNDLE_PYTHON_SITE_PACKAGES_DIR/ --exclude __pycache__

   mk_sym_link $BUNDLE_CONTENTS_DIR/MacOS/lib ../../Resources/python python$VERSION_major_python
}

function postbundle_python_packages() {
    install_name_change $DEPS_LIB_DIR/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyodbc.cpython-${VERSION_major_python//./}m-darwin.so
    install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/cryptography/hazmat/bindings/_openssl.abi3.so
    install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/cryptography/hazmat/bindings/_openssl.abi3.so
    install_name_change $DEPS_LIB_DIR/$LINK_libffi @rpath/$LINK_libffi $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/_cffi_backend.cpython-${VERSION_major_python//./}m-darwin.so
}

