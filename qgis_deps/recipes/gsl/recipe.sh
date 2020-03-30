#!/bin/bash

DESC_gsl="Numerical library for C and C++"

# version of your package
VERSION_gsl=2.6

LINK_libgsl_version=25
LINK_libgslcblas_version=0

# dependencies of this recipe
DEPS_gsl=()

# url of the package
URL_gsl=https://ftp.gnu.org/gnu/gsl/gsl-${VERSION_gsl}.tar.gz

# md5 of the package
MD5_gsl=bda73a3dd5ff2f30b5956764399db6e7

# default build path
BUILD_gsl=$BUILD_PATH/gsl/$(get_directory $URL_gsl)

# default recipe path
RECIPE_gsl=$RECIPES_PATH/gsl

patch_gsl_linker_links () {
  install_name_tool -id "@rpath/libgsl.dylib" ${STAGE_PATH}/lib/libgsl.dylib
  install_name_tool -id "@rpath/libgslcblas.dylib" ${STAGE_PATH}/lib/libgslcblas.dylib

  if [ ! -f "${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib does not exist... maybe you updated the gsl version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib does not exist... maybe you updated the gsl version?"
  fi

  install_name_tool -change "${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib" "@rpath/libgsl.${LINK_libgsl_version}.dylib" ${STAGE_PATH}/bin/gsl-histogram
  install_name_tool -change "${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib" "@rpath/libgslcblas.${LINK_libgslcblas_version}.dylib" ${STAGE_PATH}/bin/gsl-histogram
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/gsl-histogram

  install_name_tool -change "${STAGE_PATH}/lib/libgsl.${LINK_libgsl_version}.dylib" "@rpath/libgsl.${LINK_libgsl_version}.dylib" ${STAGE_PATH}/bin/gsl-randist
  install_name_tool -change "${STAGE_PATH}/lib/libgslcblas.${LINK_libgslcblas_version}.dylib" "@rpath/libgslcblas.${LINK_libgslcblas_version}.dylib" ${STAGE_PATH}/bin/gsl-randist
  install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/bin/gsl-randist
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gsl() {
  cd $BUILD_gsl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_gsl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libgsl.dylib -nt $BUILD_gsl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gsl() {
  try rsync -a $BUILD_gsl/ $BUILD_PATH/gsl/build-$ARCH/
  try cd $BUILD_PATH/gsl/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  patch_gsl_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_gsl() {
  verify_lib "libgsl.dylib"
  verify_lib "libgslcblas.dylib"

  verify_bin gsl-histogram
  verify_bin gsl-randist
}
