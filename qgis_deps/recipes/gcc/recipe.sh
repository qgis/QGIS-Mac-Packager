#!/bin/bash

DESC_gcc="gcc"

# we need this to compile FORTRAN
# this is taken from homebrew for now
# so we do not need to build it.
# fix openblas in case we build it
VERSION_gcc_major=9
VERSION_gcc=${VERSION_gcc_major}.3.0

LINK_libgfortran=libgfortran.5.dylib
LINK_gcc_s=libgcc_s.1.dylib
LINK_libquadmath=libquadmath.0.dylib

# dependencies of this recipe
DEPS_gcc=(zlib)

# url of the package
URL_gcc=https://ftp.gnu.org/gnu/gcc/gcc-${VERSION_gcc}/gcc-${VERSION_gcc}.tar.xz

# md5 of the package
MD5_gcc=d00a144b771ddeb021b61aa205b7e345

# default build path
BUILD_gcc=$BUILD_PATH/gcc/$(get_directory $URL_gcc)

# default recipe path
RECIPE_gcc=$RECIPES_PATH/gcc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gcc() {
  cd $BUILD_gcc

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # patch_configure_file configure

  touch .patched
}

function shouldbuild_gcc() {
  if [ ${STAGE_PATH}/lib/${LINK_libgfortran} -nt $BUILD_gcc/.patched ]; then
    DO_BUILD=0
  fi
}

# TODO compile ourselves!
# function build_gcc() {
#  try rsync -a $BUILD_gcc/ $BUILD_PATH/gcc/build-$ARCH/
#  try cd $BUILD_PATH/gcc/build-$ARCH
#  push_env
#
#  unset LD

#  try ${CONFIGURE} \
#    --enable-languages=fortran \
#    --disable-multilib \
#    --disable-nls \
#    --with-system-zlib \
#    --enable-checking=release \
#    --program-suffix=-${VERSION_gcc_major} \
#    --with-native-system-header-dir=/usr/include \
#    --with-sysroot=`xcrun --show-sdk-path`

#  check_file_configuration config.status

#  try $MAKESMP "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
#  try $MAKESMP install

#  pop_env
#}

# function called to build the source code
function build_gcc() {
  try cp /usr/local/opt/gcc/lib/gcc/${VERSION_gcc_major}/$LINK_libgfortran ${STAGE_PATH}/lib/
  try cp /usr/local/opt/gcc/lib/gcc/${VERSION_gcc_major}/$LINK_libquadmath ${STAGE_PATH}/lib/
  try cp /usr/local/opt/gcc/lib/gcc/${VERSION_gcc_major}/$LINK_gcc_s ${STAGE_PATH}/lib/

  try chmod +w ${STAGE_PATH}/lib/$LINK_libgfortran
  try chmod +w ${STAGE_PATH}/lib/$LINK_libquadmath
  try chmod +w ${STAGE_PATH}/lib/$LINK_gcc_s

  try install_name_tool -id ${STAGE_PATH}/lib/$LINK_libgfortran ${STAGE_PATH}/lib/$LINK_libgfortran
  try install_name_tool -id $STAGE_PATH/lib/$LINK_libquadmath $STAGE_PATH/lib/$LINK_libquadmath
  try install_name_tool -id $STAGE_PATH/lib/$LINK_gcc_s $STAGE_PATH/lib/$LINK_gcc_s

  try install_name_tool -change /usr/local/Cellar/gcc/${VERSION_gcc}/lib/gcc/${VERSION_gcc_major}/$LINK_libquadmath $STAGE_PATH/lib/$LINK_libquadmath ${STAGE_PATH}/lib/$LINK_libgfortran
	try install_name_tool -change /usr/local/lib/gcc/${VERSION_gcc_major}/$LINK_gcc_s $STAGE_PATH/lib/$LINK_gcc_s ${STAGE_PATH}/lib/$LINK_libgfortran
  try install_name_tool -change /usr/local/lib/gcc/${VERSION_gcc_major}/$LINK_gcc_s $STAGE_PATH/lib/$LINK_gcc_s ${STAGE_PATH}/lib/$LINK_libquadmath
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