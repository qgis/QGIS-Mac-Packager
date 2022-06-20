#!/bin/bash

DESC_gsl="Numerical library for C and C++"


LINK_libgsl=libgsl.25.dylib
LINK_libgslcblas=libgslcblas.0.dylib

DEPS_gsl=()


# md5 of the package

# default build path
BUILD_gsl=${DEPS_BUILD_PATH}/gsl/$(get_directory $URL_gsl)

# default recipe path
RECIPE_gsl=$RECIPES_PATH/gsl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gsl() {
  cd $BUILD_gsl
  patch_configure_file configure
  try rsync  -a $BUILD_gsl/ ${DEPS_BUILD_PATH}/gsl/build-${ARCH}
}


# function called after all the compile have been done
function postbuild_gsl() {
  verify_binary lib/$LINK_libgsl
  verify_binary lib/$LINK_libgslcblas

  verify_binary bin/gsl-histogram
  verify_binary bin/gsl-randist
}

# function to append information to config file
function add_config_info_gsl() {
  append_to_config_file "# gsl-${VERSION_gsl}: ${DESC_gsl}"
  append_to_config_file "export VERSION_gsl=${VERSION_gsl}"
  append_to_config_file "export LINK_libgsl=${LINK_libgsl}"
  append_to_config_file "export LINK_libgslcblas=${LINK_libgslcblas}"
}
