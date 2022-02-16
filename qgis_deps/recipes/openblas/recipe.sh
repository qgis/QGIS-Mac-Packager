#!/bin/bash

DESC_openblas="optimized BLAS library based on GotoBLAS2"

source $RECIPES_PATH/gcc/recipe.sh
# version of your package
VERSION_openblas=0.3.10

LINK_libopenblas=libopenblas.0.dylib
LINK_libopenblasp=libopenblasp-r0.3.10.dylib

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
  try rsync -a $BUILD_openblas/ ${BUILD_PATH}/openblas/build-${ARCH}


}

function shouldbuild_openblas() {
  if [ ${STAGE_PATH}/lib/${LINK_libopenblas} -nt $BUILD_openblas/.patched ]; then
    DO_BUILD=0
  fi
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