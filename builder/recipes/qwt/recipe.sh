#!/bin/bash

# version of your package
VERSION_qwt=6.1.4

# dependencies of this recipe
DEPS_qwt=()

# url of the package
URL_qwt=https://downloads.sourceforge.net/project/qwt/qwt/${VERSION_qwt}/qwt-${VERSION_qwt}.tar.bz2

# md5 of the package
MD5_qwt=4fb1852f694420e3ab9c583526edecc5

# default build path
BUILD_qwt=$BUILD_PATH/qwt/$(get_directory $URL_qwt)

# default recipe path
RECIPE_qwt=$RECIPES_PATH/qwt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qwt() {
  cd $BUILD_qwt

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # Install in stage path
  try ${SED} "s;QWT_INSTALL_PREFIX.*=.*;QWT_INSTALL_PREFIX=$STAGE_PATH;g" qwtconfig.pri

  # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`
  try ${SED} "s;= \$\${QWT_INSTALL_PREFIX}/plugins/designer;=$STAGE_PATH/lib/qt/plugins/designer;g" qwtconfig.pri

  touch .patched
}

function shouldbuild_qwt() {
  # If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/qt/plugins/designer/libqwt_designer_plugin.dylib" -nt $BUILD_qwt/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qwt() {
  try rsync -a $BUILD_qwt/ $BUILD_PATH/qwt/build-$ARCH/
  try cd $BUILD_PATH/qwt/build-$ARCH
  push_env

  try ${QMAKE}

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_qwt() {
  verify_lib "qt/plugins/designer/libqwt_designer_plugin.dylib"
  verify_lib "qwt.framework/qwt"
}
