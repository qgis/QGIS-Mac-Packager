#!/bin/bash

DESC_openblas="optimized BLAS library based on GotoBLAS2"

source $RECIPES_PATH/gcc/recipe.sh
# version of your package
VERSION_openblas=0.3.23

LINK_libopenblas=libopenblas.0.dylib
LINK_libopenblasp=libopenblasp-r0.3.23.dylib

# dependencies of this recipe
DEPS_openblas=(sqlite libxml2 openssl gcc)

# url of the package
URL_openblas=https://github.com/xianyi/OpenBLAS/archive/v$VERSION_openblas.tar.gz

# md5 of the package
MD5_openblas=115634b39007de71eb7e75cf7591dfb2

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
  # lapacke_sggsvd_work.c:48:9: error: implicit declaration of function 'sggsvd_' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
  export CFLAGS="$CFLAGS -Wno-implicit-function-declaration"
  export CXXFLAGS="$CFLAGS"

  # Contains FORTRAN LAPACK sources
  export DYNAMIC_ARCH=1
  export USE_OPENMP=0 # ? this is 1 in homebrew..?..
  export NO_AVX512=1

  try $MAKESMP FC=gfortran libs netlib shared
  try $MAKE install PREFIX=$STAGE_PATH

  unset DYNAMIC_ARCH
  unset USE_OPENMP
  unset NO_AVX512

  pop_env
}

# function called after all the compile have been done
function postbuild_openblas() {
  verify_binary lib/$LINK_libopenblas
  verify_binary lib/$LINK_libopenblasp
}

# function to append information to config file
function add_config_info_openblas() {
  append_to_config_file "# openblas-${VERSION_openblas}: ${DESC_openblas}"
  append_to_config_file "export VERSION_openblas=${VERSION_openblas}"
  append_to_config_file "export LINK_libopenblas=${LINK_libopenblas}"
  append_to_config_file "export LINK_libopenblasp=${LINK_libopenblasp}"
}