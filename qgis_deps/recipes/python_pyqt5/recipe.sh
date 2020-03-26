#!/bin/bash

# version of your package
VERSION_MAJOR_python_pyqt5=5.14.2
VERSION_python_pyqt5=${VERSION_MAJOR_python_pyqt5}.dev2003150552

# dependencies of this recipe
DEPS_python_pyqt5=(python_sip)

# url of the package
URL_python_pyqt5=https://www.riverbankcomputing.com/static/Downloads/PyQt5/PyQt5-${VERSION_python_pyqt5}.tar.gz

# echo "${URL_python_pyqt5}"

# md5 of the package
MD5_python_pyqt5=f6aaf805d73074f1eb23a00ad37ef66f

# default build path
BUILD_python_pyqt5=$BUILD_PATH/python_pyqt5/$(get_directory $URL_python_pyqt5)

# default recipe path
RECIPE_python_pyqt5=$RECIPES_PATH/python_pyqt5

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyqt5() {
  try mkdir -p $BUILD_python_pyqt5
  cd $BUILD_python_pyqt5

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_pyqt5() {
  if python_package_installed PyQt5; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_pyqt5() {
  try rsync -a $BUILD_python_pyqt5/ $BUILD_PATH/python_pyqt5/build-$ARCH/
  try cd $BUILD_PATH/python_pyqt5/build-$ARCH

  push_env

  try $PYCONFIGURE \
    --confirm-license \
    --stubsdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --sipdir=$STAGE_PATH/share/sip/PyQt5 \
    --bindir=$STAGE_PATH/bin \
    --sip-incdir=$STAGE_PATH/include \
    --destdir=$QGIS_SITE_PACKAGES_PATH \
    --disable=QtWebKit \
    --disable=QtWebKitWidgets \
    --disable=QAxContainer \
    --disable=QtX11Extras \
    --disable=QtWinExtras \
    --disable=Enginio \
    --designer-plugindir=$STAGE_PATH/share/plugins \
    --qml-plugindir=$STAGE_PATH/share/plugins

  try $MAKESMP
  try $MAKE install
  try $MAKE clean

  pop_env
}

function postbuild_python_pyqt5() {
   if ! python_package_installed PyQt5; then
      error "Missing python package PyQt5"
   fi
}
