#!/bin/bash

DESC_gcc="gcc"

# we need this to compile FORTRAN

LINK_libgfortran=libgfortran.5.dylib
LINK_gcc_s=libgcc_s.1.dylib
LINK_libquadmath=libquadmath.0.dylib

DEPS_gcc=(zlib gmp mpfr libmpc libisl)


# md5 of the package

# default build path
BUILD_gcc=${DEPS_BUILD_PATH}/gcc/$(get_directory $URL_gcc)

# default recipe path
RECIPE_gcc=$RECIPES_PATH/gcc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gcc() {
  cd $BUILD_gcc
  try rsync -a $BUILD_gcc/ ${DEPS_BUILD_PATH}/gcc/build-${ARCH}
}

function shouldbuild_gcc() {
  if [ ${STAGE_PATH}/lib/${LINK_libgfortran} -nt $BUILD_gcc/.patched ]; then
    DO_BUILD=0
  fi
}

# function called after all the compile have been done
function postbuild_gcc() {
  verify_binary lib/$LINK_libgfortran
  verify_binary lib/$LINK_libquadmath
  verify_binary lib/$LINK_gcc_s
}

# function to append information to config file
function add_config_info_gcc() {
  append_to_config_file "# gcc-${VERSION_gcc}: ${DESC_gcc}"
  append_to_config_file "export VERSION_gcc=${VERSION_gcc}"
  append_to_config_file "export VERSION_gcc_major=${VERSION_gcc_major}"
  append_to_config_file "export LINK_libgfortran=$LINK_libgfortran"
  append_to_config_file "export LINK_libquadmath=$LINK_libquadmath"
  append_to_config_file "export LINK_gcc_s=$LINK_gcc_s"
}