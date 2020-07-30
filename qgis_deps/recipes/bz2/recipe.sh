#!/bin/bash

DESC_bz2="Portable Foreign Function Interface library"

# version of your package
VERSION_bz2_major=1.0
VERSION_bz2=$VERSION_bz2_major.8
LINK_bz2=libbz2.$VERSION_bz2_major.dylib

# dependencies of this recipe
DEPS_bz2=()

# url of the package
URL_bz2=https://sourceware.org/pub/bzip2/bzip2-${VERSION_bz2}.tar.gz

# md5 of the package
MD5_bz2=67e051268d0c475ea773822f7500d0e5

# default build path
BUILD_bz2=$BUILD_PATH/bz2/$(get_directory $URL_bz2)

# default recipe path
RECIPE_bz2=$RECIPES_PATH/bz2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_bz2() {
  cd $BUILD_bz2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_bz2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_bz2 -nt $BUILD_bz2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_bz2() {
  try rsync -a $BUILD_bz2/ $BUILD_PATH/bz2/build-$ARCH/
  try cd $BUILD_PATH/bz2/build-$ARCH
  push_env

  try $MAKESMP PREFIX=$STAGE_PATH
  try $MAKE install PREFIX=$STAGE_PATH

  try ${SED} "s;-shared -Wl,-soname -Wl,libbz2.so.$VERSION_bz2_major -o libbz2.so.$VERSION_bz2;-dynamiclib -install_name libbz2.$VERSION_bz2_major.dylib -current_version $VERSION_bz2 -compatibility_version $VERSION_bz2_major -o libbz2.$VERSION_bz2.dylib;g" Makefile-libbz2_so
  try ${SED} "s;libbz2.so.$VERSION_bz2;libbz2.$VERSION_bz2.dylib;g" Makefile-libbz2_so
  try ${SED} "s;libbz2.so.$VERSION_bz2_major;libbz2.$VERSION_bz2_major.dylib;g" Makefile-libbz2_so

  try $MAKESMP PREFIX=$STAGE_PATH -f Makefile-libbz2_so
  ln -s libbz2.$VERSION_bz2_major.dylib libbz2.dylib
  try cp -av libbz2.*dylib $STAGE_PATH/lib/
  try install_name_tool -id $STAGE_PATH/lib/libbz2.$VERSION_bz2_major.dylib $STAGE_PATH/lib/libbz2.$VERSION_bz2_major.dylib

  pop_env
}

# function called after all the compile have been done
function postbuild_bz2() {
  verify_binary lib/$LINK_bz2
}

# function to append information to config file
function add_config_info_bz2() {
  append_to_config_file "# bz2-${VERSION_bz2}: ${DESC_bz2}"
  append_to_config_file "export VERSION_bz2=${VERSION_bz2}"
  append_to_config_file "export LINK_bz2=${LINK_bz2}"
}