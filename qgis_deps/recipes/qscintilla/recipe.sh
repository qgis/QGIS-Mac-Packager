#!/bin/bash

DESC_qscintilla="Port to Qt of the Scintilla editing component"

# version of your package
# keep in SYNC with python_qscintilla receipt
VERSION_qscintilla=2.13.4

# full link version of the library
LINK_libqscintilla2_qt5=libqscintilla2_qt5.15.dylib

# dependencies of this recipe
DEPS_qscintilla=()

# url of the package
URL_qscintilla=https://www.riverbankcomputing.com/static/Downloads/QScintilla/${VERSION_qscintilla}/QScintilla_src-${VERSION_qscintilla}.tar.gz

# md5 of the package
MD5_qscintilla=4f83a4a4ad7da40eae80ad23f9fb18f2

# default build path
BUILD_qscintilla=$BUILD_PATH/qscintilla/$(get_directory $URL_qscintilla)

# default recipe path
RECIPE_qscintilla=$RECIPES_PATH/qscintilla

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qscintilla() {
  cd $BUILD_qscintilla/src

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # Install in stage path
  try ${SED} "s;\$\$\[QT_INSTALL_LIBS\];$STAGE_PATH/lib;g" qscintilla.pro
  try ${SED} "s;\$\$\[QT_INSTALL_HEADERS\];$STAGE_PATH/include;g" qscintilla.pro
  try ${SED} "s;\$\$\[QT_INSTALL_TRANSLATIONS\];$STAGE_PATH/trans;g" qscintilla.pro
  try ${SED} "s;\$\$\[QT_INSTALL_DATA\];$STAGE_PATH/data;g" qscintilla.pro
  try ${SED} "s;\$\$\[QT_HOST_DATA\];$STAGE_PATH/data;g" qscintilla.pro

  try ${SED} "s;\$\$\[QT_INSTALL_LIBS\];$STAGE_PATH/lib;g" features/qscintilla2.prf
  try ${SED} "s;\$\$\[QT_INSTALL_HEADERS\];$STAGE_PATH/include;g" features/qscintilla2.prf

  touch .patched
}

function shouldbuild_qscintilla() {
  # If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/${LINK_libqscintilla2_qt5}" -nt $BUILD_qscintilla/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qscintilla() {
  try rsync -a $BUILD_qscintilla/ $BUILD_PATH/qscintilla/build-$ARCH/
  try cd $BUILD_PATH/qscintilla/build-$ARCH
  push_env

  cd src
  try ${QMAKE} qscintilla.pro

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_qscintilla() {
  verify_binary lib/$LINK_libqscintilla2_qt5
}

# function to append information to config file
function add_config_info_qscintilla() {
  append_to_config_file "# qscintilla-${VERSION_qscintilla}: ${DESC_qscintilla}"
  append_to_config_file "export VERSION_qscintilla=${VERSION_qscintilla}"
  append_to_config_file "export LINK_libqscintilla2_qt5=${LINK_libqscintilla2_qt5}"
}