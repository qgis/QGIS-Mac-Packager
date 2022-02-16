#!/bin/bash

DESC_gsl="Numerical library for C and C++"

# version of your package
VERSION_gsl=2.6

LINK_libgsl=libgsl.25.dylib
LINK_libgslcblas=libgslcblas.0.dylib

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

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gsl() {
  cd $BUILD_gsl
    patch_configure_file configure
  try rsync  -a $BUILD_gsl/ ${BUILD_PATH}/gsl/build-${ARCH}

}

function shouldbuild_gsl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libgsl -nt $BUILD_gsl/.patched ]; then
    DO_BUILD=0
  fi
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
