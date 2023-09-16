#!/bin/bash

DESC_re2="Alternative to backtracking PCRE-style regular expression engines"

# version of your package
VERSION_re2=2023-07-01
LINK_re2_version=11.0.0
LINK_re2=libre2.${LINK_re2_version}.dylib

# dependencies of this recipe
DEPS_re2=(abseil_cpp)

# url of the package
URL_re2=https://github.com/google/re2/releases/download/${VERSION_re2}/re2-${VERSION_re2}.tar.gz

# md5 of the package
MD5_re2=52b9786ca6fbc679869fee2b6fef25a5

# default build path
BUILD_re2=$BUILD_PATH/re2/$(get_directory $URL_re2)

# default recipe path
RECIPE_re2=$RECIPES_PATH/re2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_re2() {
  cd $BUILD_re2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_re2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_re2 -nt $BUILD_re2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_re2() {
  try mkdir -p $BUILD_PATH/re2/build-$ARCH
  try cd $BUILD_PATH/re2/build-$ARCH
  push_env

  try ${CMAKE} \
    -B build-static \
    -DRE2_BUILD_TESTING=OFF \
    $BUILD_re2
  check_file_configuration CMakeCache.txt

  try ${CMAKE} --build build-static
  try ${CMAKE} --install build-static

  try ${CMAKE} \
    -B build-shared \
    -DBUILD_SHARED_LIBS=ON \
    -DRE2_BUILD_TESTING=OFF \
    $BUILD_re2
  check_file_configuration CMakeCache.txt

  try ${CMAKE} --build build-shared
  try ${CMAKE} --install build-shared

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libre2*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_re2() {
  verify_binary lib/$LINK_re2
}

# function to append information to config file
function add_config_info_re2() {
  append_to_config_file "# re2-${VERSION_re2}: ${DESC_re2}"
  append_to_config_file "export VERSION_re2=${VERSION_re2}"
  append_to_config_file "export LINK_re2=${LINK_re2}"
}