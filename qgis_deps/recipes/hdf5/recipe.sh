#!/bin/bash

DESC_hdf5="File format designed to store large amounts of data"

# version of your package
VERSION_hdf5_major=1.10
VERSION_hdf5=${VERSION_hdf5_major}.0

LINK_libhdf5_version=100

# dependencies of this recipe
DEPS_hdf5=()

# url of the package
URL_hdf5=https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${VERSION_hdf5_major}/hdf5-${VERSION_hdf5}/src/hdf5-${VERSION_hdf5}.tar.bz2

# md5 of the package
MD5_hdf5=355243bda5df386aea25f079d550947b

# default build path
BUILD_hdf5=$BUILD_PATH/hdf5/$(get_directory $URL_hdf5)

# default recipe path
RECIPE_hdf5=$RECIPES_PATH/hdf5

patch_hdf5_linker_links () {
  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libhdf5.${LINK_libhdf5_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libhdf5.${LINK_libhdf5_version}.dylib does not exist... maybe you updated the hdf5 version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libhdf5_cpp.100.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libhdf5_cpp.${LINK_libhdf5_version}.dylib does not exist... maybe you updated the hdf5 version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libhdf5_hl.100.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libhdf5_hl.${LINK_libhdf5_version}.dylib does not exist... maybe you updated the hdf5 version?"
  fi

  # these are bash scripts
  # bin/h5c++
  # bin/h5cc
  # bin/h5redeploy

  targets=(
    lib/libhdf5_hl.dylib
    lib/libhdf5_hl_cpp.dylib
    lib/libhdf5_cpp.dylib
    bin/gif2h5
    bin/h52gif

    bin/h5clear
    bin/h5copy
    bin/h5debug
    bin/h5diff
    bin/h5dump
    bin/h5format_convert
    bin/h5import
    bin/h5jam
    bin/h5ls
    bin/h5mkgrp
    bin/h5perf_serial

    bin/h5repack
    bin/h5repart
    bin/h5stat
    bin/h5unjam
    bin/h5watch
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libhdf5.${LINK_libhdf5_version}.dylib" "@rpath/libhdf5.${LINK_libhdf5_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libhdf5_cpp.${LINK_libhdf5_version}.dylib" "@rpath/libhdf5_cpp.${LINK_libhdf5_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libhdf5_hl.${LINK_libhdf5_version}.dylib" "@rpath/libhdf5_hl.${LINK_libhdf5_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_hdf5() {
  cd $BUILD_hdf5

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_hdf5() {
  if [ ${STAGE_PATH}/lib/libhdf5.dylib -nt $BUILD_hdf5/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_hdf5() {
  try rsync -a $BUILD_hdf5/ $BUILD_PATH/hdf5/build-$ARCH/
  try cd $BUILD_PATH/hdf5/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --enable-build-mode=release \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --enable-build-mode=production \
    --enable-cxx \
    --disable-fortran \
    --with-szlib=no
    # enable-parallel ??? MPI Support

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  install_name_tool -id "@rpath/libhdf5.dylib" ${STAGE_PATH}/lib/libhdf5.dylib
  install_name_tool -id "@rpath/libhdf5_hl.dylib" ${STAGE_PATH}/lib/libhdf5_hl.dylib
  install_name_tool -id "@rpath/libhdf5_cpp.dylib" ${STAGE_PATH}/lib/libhdf5_cpp.dylib
  install_name_tool -id "@rpath/libhdf5_hl_cpp.dylib" ${STAGE_PATH}/lib/libhdf5_hl_cpp.dylib

  patch_hdf5_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_hdf5() {
  verify_lib "libhdf5.dylib"
  verify_lib "libhdf5_hl.dylib"
  verify_lib "libhdf5_cpp.dylib"
  verify_lib "libhdf5_hl_cpp.dylib"

  verify_bin "h5copy"
}
