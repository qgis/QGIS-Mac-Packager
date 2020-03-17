#!/bin/bash

# version of your package
VERSION_hdf5_major=1.12
VERSION_hdf5=${VERSION_hdf5_major}.0

# dependencies of this recipe
DEPS_hdf5=()

# url of the package
URL_hdf5=https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${VERSION_hdf5_major}/hdf5-${VERSION_hdf5}/src/hdf5-${VERSION_hdf5}.tar.bz2

# md5 of the package
MD5_hdf5=1fa68c4b11b6ef7a9d72ffa55995f898

# default build path
BUILD_hdf5=$BUILD_PATH/hdf5/$(get_directory $URL_hdf5)

# default recipe path
RECIPE_hdf5=$RECIPES_PATH/hdf5

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
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libhdf5.dylib -nt $BUILD_hdf5/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_hdf5() {
  try rsync -a $BUILD_hdf5/ $BUILD_PATH/hdf5/build-$ARCH/
  try cd $BUILD_PATH/hdf5/build-$ARCH
  push_env

  try ${BUILD_hdf5}/${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --enable-build-mode=production \
    --enable-cxx \
    --disable-fortran \
    --with-szlib=no

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_hdf5() {
  verify_lib "${STAGE_PATH}/lib/libhdf5.dylib"
}
