#!/bin/bash

DESC_openblas="optimized BLAS library based on GotoBLAS2"

source $RECIPES_PATH/gcc/recipe.sh

LINK_libopenblas=libopenblas.0.dylib
LINK_libopenblasp=libopenblasp-r${VERSION_openblas}.dylib

DEPS_openblas=(sqlite libxml2 openssl gcc)


# md5 of the package

# default build path
BUILD_openblas=${DEPS_BUILD_PATH}/openblas/$(get_directory $URL_openblas)

# default recipe path
RECIPE_openblas=$RECIPES_PATH/openblas

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_openblas() {
  cd $BUILD_openblas
  try rsync -a $BUILD_openblas/ ${DEPS_BUILD_PATH}/openblas/build-${ARCH}


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