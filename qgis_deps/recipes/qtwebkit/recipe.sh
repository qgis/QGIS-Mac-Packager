#!/bin/bash

DESC_qtwebkit="WebKit extension for QT5"

# version of your package
VERSION_QTwebkit=${VERSION_QT}

# dependencies of this recipe
DEPS_qtwebkit=( sqlite bison webp zlib libxslt jpeg png libtiff libicu )

# url of the package
URL_qtwebkit=https://github.com/qt/qtwebkit/archive/v5.212.0-alpha4.tar.gz

# md5 of the package
MD5_qtwebkit=22e442063e7d0362439934442e269ed2

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

  #https://github.com/qtwebkit/qtwebkit/pull/1012/files
  try patch --verbose --forward -p1 < $RECIPE_qtwebkit/patches/bison37.patch

  # Ambiguous Handle (also in MacPorts.h)
  try ${SED} 's;isReachableFromOpaqueRoots(Handle<JSC::Unknown>;isReachableFromOpaqueRoots(JSC::Handle<JSC::Unknown>;g' Source/JavaScriptCore/jsc.cpp

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
    -DPORT=Qt \
    -DENABLE_TOOLS=FALSE \
    -DENABLE_API_TESTS=FALSE \
    -DSHOULD_INSTALL_JS_SHELL=FALSE \
    -DUSE_LIBHYPHEN=OFF \
    -DMACOS_USE_SYSTEM_ICU=OFF \
    -DMACOS_FORCE_SYSTEM_XML_LIBRARIES=OFF \
    -DQT_INSTALL_PREFIX=$QT_BASE/clang_64 \
    $BUILD_qtwebkit

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env
}

# function called after all the compile have been done
function postbuild_qtwebkit() {
  verify_binary lib/qml/QtWebKit/experimental/libqmlwebkitexperimentalplugin.so
  verify_binary lib/qml/QtWebKit/libqmlwebkitplugin.so
}

# function to append information to config file
function add_config_info_qtwebkit() {
  append_to_config_file "# qtwebkit-${VERSION_QTwebkit}: ${DESC_qtwebkit}"
  append_to_config_file "export VERSION_QTwebkit=${VERSION_QTwebkit}"
}