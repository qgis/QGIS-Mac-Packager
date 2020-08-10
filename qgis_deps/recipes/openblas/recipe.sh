#!/bin/bash

DESC_openblas="optimized BLAS library based on GotoBLAS2"

source $RECIPES_PATH/gcc/recipe.sh
# version of your package
VERSION_openblas=0.3.10

LINK_libopenblas=libopenblas.0.dylib
LINK_libopenblas_haswellp=libopenblas_haswellp-r$VERSION_openblas.dylib

# dependencies of this recipe
DEPS_openblas=(sqlite libxml2 openssl gcc)

# url of the package
URL_openblas=https://github.com/xianyi/OpenBLAS/archive/v$VERSION_openblas.tar.gz

# md5 of the package
MD5_openblas=4727a1333a380b67c8d7c7787a3d9c9a

# default build path
BUILD_openblas=$BUILD_PATH/openblas/$(get_directory $URL_openblas)

# default recipe path
RECIPE_openblas=$RECIPES_PATH/openblas

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_openblas() {
  cd $BUILD_openblas

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_openblas() {
  if [ ${STAGE_PATH}/lib/${LINK_libopenblas} -nt $BUILD_openblas/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_openblas() {
  try rsync -a $BUILD_openblas/ $BUILD_PATH/openblas/build-$ARCH/
  try cd $BUILD_PATH/openblas/build-$ARCH

  push_env

  export CFLAGS="$CFLAGS -mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET"
  export CXXFLAGS="$CFLAGS"

  # Contains FORTRAN LAPAC sources
  try $MAKESMP FC=gfortran libs netlib shared
  try $MAKE install PREFIX=$STAGE_PATH

  pop_env
}

# function called after all the compile have been done
function postbuild_openblas() {
  verify_binary lib/$LINK_libopenblas
  verify_binary lib/$LINK_libopenblas_haswellp
}

# function to append information to config file
function add_config_info_openblas() {
  append_to_config_file "# openblas-${VERSION_openblas}: ${DESC_openblas}"
  append_to_config_file "export VERSION_openblas=${VERSION_openblas}"
  append_to_config_file "export LINK_libopenblas=${LINK_libopenblas}"
  append_to_config_file "export LINK_libopenblas_haswellp=${LINK_libopenblas_haswellp}"
}