#!/bin/bash

DESC_boost="Collection of portable C++ source libraries"

# version of your package
# version required by MySQL
VERSION_boost=1.70.0

# dependencies of this recipe
DEPS_boost=(zlib python)

# url of the package
# URL_boost=https://sourceforge.net/projects/boost/files/boost/${VERSION_boost}/boost_${VERSION_boost//./_}.tar.bz2
URL_boost=https://dl.bintray.com/boostorg/release/${VERSION_boost}/source/boost_${VERSION_boost//./_}.tar.bz2

# from github it does not contain submodules in the build subdir
# URL_boost=https://github.com/boostorg/boost/archive/boost-${VERSION_boost}.tar.gz

# md5 of the package
MD5_boost=242ecc63507711d6706b9b0c0d0c7d4f

# default build path
BUILD_boost=$BUILD_PATH/boost/$(get_directory $URL_boost)

# default recipe path
RECIPE_boost=$RECIPES_PATH/boost

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_boost() {
  cd $BUILD_boost

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_boost() {
  # If lib is newer than the sourcecode skip build
  pyver=${VERSION_major_python//./}
  if [ ${STAGE_PATH}/lib/libboost_python${pyver}.dylib -nt $BUILD_boost/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_boost() {
  try rsync -a $BUILD_boost/ $BUILD_PATH/boost/build-$ARCH/
  try cd $BUILD_PATH/boost/build-$ARCH
  push_env

  try ./bootstrap.sh \
    --prefix="${STAGE_PATH}" \
    --with-toolset=clang \
    --with-icu="${PREFIX}" \
    --with-python="${PYTHON}" \
    --with-python-root="${STAGE_PATH} : ${STAGE_PATH}/include/python${VERSION_major_python}m : ${STAGE_PATH}/include/python${VERSION_major_python}"

  try ./b2 -q \
    variant=release \
    debug-symbols=off \
    threading=multi \
    runtime-link=shared \
    link=static,shared \
    toolset=clang \
    python="${VERSION_major_python}" \
    include="${STAGE_PATH}/include" \
    cxxflags="${CXXFLAGS}" \
    linkflags="-L$${STAGE_PATH}/lib" \
    --layout=system \
    --with-python \
    -j"${CORES}" \
    install

  pop_env
}

# function called after all the compile have been done
function postbuild_boost() {
  verify_lib libboost_python${VERSION_major_python//./}.dylib
}

# function to append information to config file
function add_config_info_boost() {
  append_to_config_file "# boost-${VERSION_boost}: ${DESC_boost}"
  append_to_config_file "export VERSION_boost=${VERSION_boost}"
}
