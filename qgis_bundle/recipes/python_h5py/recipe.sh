#!/bin/bash

function check_python_h5py() {
  env_var_exists VERSION_python_h5py
}

function bundle_python_h5py() {
  :
}

function postbundle_python_h5py() {
  for i in \
    defs \
    _proxy \
    h5fd \
    h5f \
    h5ds \
    h5l \
    h5d \
    h5s \
    utils \
    _objects \
    h5g \
    h5 \
    h5o \
    _errors \
    h5t \
    _conv \
    h5z \
    h5r \
    h5i \
    h5ac \
    h5a \
    h5pl \
    h5p
  do
    install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/$i.cpython-${VERSION_major_python//./}m-darwin.so
    install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

