#!/bin/bash

DESC_snappy="Compression/decompression library aiming for high speed"

# version of your package
VERSION_snappy=1.1.10
LINK_snappy_version=1.1.10
LINK_snappy=libsnappy.${LINK_snappy_version}.dylib

# dependencies of this recipe
DEPS_snappy=(pkg_config)

# url of the package
URL_snappy=https://github.com/google/snappy/archive/refs/tags/${VERSION_snappy}.tar.gz

# md5 of the package
MD5_snappy=70153395ebe6d72febe2cf2e40026a44

# default build path
BUILD_snappy=$BUILD_PATH/snappy/$(get_directory $URL_snappy)

# default recipe path
RECIPE_snappy=$RECIPES_PATH/snappy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_snappy() {
  cd $BUILD_snappy

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # https://github.com/google/snappy/commit/27f34a580be4a3becf5f8c0cba13433f53c21337
  try patch --verbose --forward -p1 < $RECIPE_snappy/patches/27f34a580be4a3becf5f8c0cba13433f53c21337.patch

  touch .patched
}

function shouldbuild_snappy() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_snappy -nt $BUILD_snappy/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_snappy() {
  try mkdir -p $BUILD_PATH/snappy/build-$ARCH
  try cd $BUILD_PATH/snappy/build-$ARCH
  push_env

  try ${CMAKE} \
    -DSNAPPY_BUILD_TESTS=OFF \
    -DSNAPPY_BUILD_BENCHMARKS=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_CXX_STANDARD=17 \
    $BUILD_snappy
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libsnappy*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_snappy() {
  verify_binary lib/$LINK_snappy
}

# function to append information to config file
function add_config_info_snappy() {
  append_to_config_file "# snappy-${VERSION_snappy}: ${DESC_snappy}"
  append_to_config_file "export VERSION_snappy=${VERSION_snappy}"
  append_to_config_file "export LINK_snappy=${LINK_snappy}"
}