#!/bin/bash

DESC_mpfr="C library for multiple-precision floating-point computations"

LINK_mpfr=libmpfr.6.dylib

DEPS_mpfr=(gmp)

# default build path
BUILD_mpfr=${DEPS_BUILD_PATH}/mpfr/$(get_directory $URL_mpfr)

# default recipe path
RECIPE_mpfr=$RECIPES_PATH/mpfr

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mpfr() {
  cd $BUILD_mpfr
    patch_configure_file configure
  try rsync  -a $BUILD_mpfr/ ${DEPS_BUILD_PATH}/mpfr/build-${ARCH}

}

# function called after all the compile have been done
function postbuild_mpfr() {
  verify_binary lib/$LINK_mpfr
}

# function to append information to config file
function add_config_info_mpfr() {
  append_to_config_file "# mpfr-${VERSION_mpfr}: ${DESC_mpfr}"
  append_to_config_file "export VERSION_mpfr=${VERSION_mpfr}"
  append_to_config_file "export LINK_mpfr=${LINK_mpfr}"
}
