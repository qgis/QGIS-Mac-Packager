#!/bin/bash

# version of your package
VERSION_qtwebkit=${VERSION_qt}

# dependencies of this recipe
DEPS_qtwebkit=( sqlite bison webp zlib libxslt jpeg png)

# url of the package
URL_qtwebkit=https://github.com/qt/qtwebkit/archive/ab1bd15209abaf7effc51dbc2f272c5681af7223.tar.gz

# md5 of the package
MD5_qtwebkit=1327ff09b6d8cf5089fab52c18c03abb

# default build path
BUILD_qtwebkit=$BUILD_PATH/qtwebkit/$(get_directory $URL_qtwebkit)

# default recipe path
RECIPE_qtwebkit=$RECIPES_PATH/qtwebkit

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtwebkit() {
  cd $BUILD_qtwebkit

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qtwebkit() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/qml/QtWebKit/libqmlwebkitplugin.so -nt $BUILD_qtwebkit/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qtwebkit() {
  try mkdir -p $BUILD_PATH/qtwebkit/build-$ARCH
  try cd $BUILD_PATH/qtwebkit/build-$ARCH
  push_env

  try ${CMAKE} \
    -DCMAKE_FIND_FRAMEWORK=LAST \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -Wno-dev \
    -DPORT=Qt \
    -DENABLE_TOOLS=OFF \
    $BUILD_qtwebkit

  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_qtwebkit() {
  verify_lib qml/QtWebKit/experimental/libqmlwebkitexperimentalplugin.so
  verify_lib qml/QtWebKit/libqmlwebkitplugin.so
}
