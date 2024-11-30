#!/bin/bash

DESC_abseil_cpp="C++ Common Libraries"

# version of your package
VERSION_abseil_cpp=20230125.2
LINK_abseil_cpp_version=2301.0.0
LINK_abseil_cpp=libabsl_log_globals.${LINK_abseil_cpp_version}.dylib

# dependencies of this recipe
DEPS_abseil_cpp=()

# url of the package
URL_abseil_cpp=https://github.com/abseil/abseil-cpp/archive/refs/tags/${VERSION_abseil_cpp}.tar.gz

# md5 of the package
MD5_abseil_cpp=52b9786ca6fbc679869fee2b6fef25a5

# default build path
BUILD_abseil_cpp=$BUILD_PATH/abseil_cpp/$(get_directory $URL_abseil_cpp)

# default recipe path
RECIPE_abseil_cpp=$RECIPES_PATH/abseil_cpp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_abseil_cpp() {
  cd $BUILD_abseil_cpp

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_abseil_cpp() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_abseil_cpp -nt $BUILD_abseil_cpp/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_abseil_cpp() {
  try mkdir -p $BUILD_PATH/abseil_cpp/build-$ARCH
  try cd $BUILD_PATH/abseil_cpp/build-$ARCH
  push_env

  try ${CMAKE} \
    -DABSL_BUILD_TESTING=OFF \
    -DABSL_USE_GOOGLETEST_HEAD=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_CXX_STANDARD=17 \
    -DABSL_PROPAGATE_CXX_STD=ON \
    $BUILD_abseil_cpp
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libabsl*${LINK_abseil_cpp_version}.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_abseil_cpp() {
  verify_binary lib/$LINK_abseil_cpp
}

# function to append information to config file
function add_config_info_abseil_cpp() {
  append_to_config_file "# abseil_cpp-${VERSION_abseil_cpp}: ${DESC_abseil_cpp}"
  append_to_config_file "export VERSION_abseil_cpp=${VERSION_abseil_cpp}"
  append_to_config_file "export LINK_abseil_cpp=${LINK_abseil_cpp}"
}