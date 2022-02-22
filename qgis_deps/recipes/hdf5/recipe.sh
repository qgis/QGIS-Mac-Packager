#!/bin/bash

DESC_hdf5="File format designed to store large amounts of data"

LINK_libhdf5=libhdf5.200.dylib
LINK_libhdf5_cpp=libhdf5_cpp.200.dylib
LINK_libhdf5_hl=libhdf5_hl.200.dylib
LINK_libhdf5_hl_cpp=libhdf5_hl_cpp.200.dylib


DEPS_hdf5=()


# md5 of the package

# default build path
BUILD_hdf5=${DEPS_BUILD_PATH}/hdf5/$(get_directory $URL_hdf5)

# default recipe path
RECIPE_hdf5=$RECIPES_PATH/hdf5

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_hdf5() {
  cd $BUILD_hdf5
  patch_configure_file configure
  try rsync  -a $BUILD_hdf5/ ${DEPS_BUILD_PATH}/hdf5/build-${ARCH}
}

function shouldbuild_hdf5() {
  if [ ${STAGE_PATH}/lib/$LINK_libhdf5 -nt $BUILD_hdf5/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_hdf5() {
  verify_binary lib/$LINK_libhdf5
  verify_binary lib/$LINK_libhdf5_hl
  verify_binary lib/$LINK_libhdf5_cpp
  verify_binary lib/$LINK_libhdf5_hl_cpp
  verify_binary bin/"h5copy"
  verify_binary bin/h5perf_serial
  verify_binary bin/h5repack
  verify_binary bin/h5jam
  verify_binary bin/h5unjam
  verify_binary bin/h5format_convert
  verify_binary bin/h5stat
}

# function to append information to config file
function add_config_info_hdf5() {
  append_to_config_file "# hdf5-${VERSION_hdf5}: ${DESC_hdf5}"
  append_to_config_file "export VERSION_hdf5=${VERSION_hdf5}"
  append_to_config_file "export LINK_libhdf5=${LINK_libhdf5}"
  append_to_config_file "export LINK_libhdf5_cpp=${LINK_libhdf5_cpp}"
  append_to_config_file "export LINK_libhdf5_hl=${LINK_libhdf5_hl}"
  append_to_config_file "export LINK_libhdf5_hl_cpp=${LINK_libhdf5_hl_cpp}"
}
