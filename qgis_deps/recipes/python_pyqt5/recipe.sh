#!/bin/bash

DESC_python_pyqt5="PyQt5 package for python"

# version of your package
VERSION_python_pyqt5=$VERSION_qt

# dependencies of this recipe
DEPS_python_pyqt5=(python python_sip qtwebkit qscintilla)

# url of the package
URL_python_pyqt5=https://files.pythonhosted.org/packages/28/6c/640e3f5c734c296a7193079a86842a789edb7988dca39eab44579088a1d1/PyQt5-${VERSION_python_pyqt5}.tar.gz

# md5 of the package
MD5_python_pyqt5=b94576e9e013210dc5aba061913e4bd4

# default build path
BUILD_python_pyqt5=$BUILD_PATH/python_pyqt5/$(get_directory $URL_python_pyqt5)

# default recipe path
RECIPE_python_pyqt5=$RECIPES_PATH/python_pyqt5

function fix_python_pyqt5_paths() {
  # these are sh scripts that calls plain python{VERSION_major_python}
  # so when on path there is homebrew python or other
  # it fails
  targets=(
    bin/pylupdate5
    bin/pyrcc5
    bin/pyuic5
  )

  for i in ${targets[*]}
  do
    try ${SED} "s;exec ./python${VERSION_major_python}.${VERSION_minor_python};exec $STAGE_PATH/bin/python${VERSION_major_python}.${VERSION_minor_python};g" $STAGE_PATH/$i
    try ${SED} "s;exec python${VERSION_major_python}.${VERSION_minor_python};exec $STAGE_PATH/bin/python${VERSION_major_python}.${VERSION_minor_python};g" $STAGE_PATH/$i

    try ${SED} "s;exec ./python${VERSION_major_python};exec $STAGE_PATH/bin/python${VERSION_major_python};g" $STAGE_PATH/$i
    try ${SED} "s;exec python${VERSION_major_python};exec $STAGE_PATH/bin/python${VERSION_major_python};g" $STAGE_PATH/$i
    rm -f $STAGE_PATH/$i.orig
  done

  echo ${REPL}
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyqt5() {
  try mkdir -p $BUILD_python_pyqt5
  cd $BUILD_python_pyqt5

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # this is needed
  # so the autodetection of modules to build
  # finds out webkit modules
  MOD_DIR=$STAGE_PATH/mkspecs/modules
  try ${SED} "s;pro_lines.extend(target_config.qmake_variables);pro_lines.extend(target_config.qmake_variables)\;pro_lines.append(\"include(${MOD_DIR}/qt_lib_webkit.pri)\")\;pro_lines.append(\"include(${MOD_DIR}/qt_lib_webkitwidgets.pri)\");g" configure.py

  touch .patched
}

function shouldbuild_python_pyqt5() {
  if python_package_installed PyQt5.QtCore; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_pyqt5() {
  try rsync -a $BUILD_python_pyqt5/ $BUILD_PATH/python_pyqt5/build-$ARCH/
  try cd $BUILD_PATH/python_pyqt5/build-$ARCH

  push_env

  try $PYTHON ./configure.py \
    --confirm-license \
    --stubsdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --sipdir=$STAGE_PATH/share/sip/PyQt5 \
    --bindir=$STAGE_PATH/bin \
    --sip-incdir=$STAGE_PATH/include \
    --destdir=$QGIS_SITE_PACKAGES_PATH \
    --disable=QAxContainer \
    --disable=QtX11Extras \
    --disable=QtWinExtras \
    --disable=Enginio \
    --designer-plugindir=$STAGE_PATH/share/plugins \
    --qml-plugindir=$STAGE_PATH/share/plugins \
    --verbose

  try $MAKESMP
  try $MAKE install
  try $MAKE clean

  fix_python_pyqt5_paths

  pop_env
}

function postbuild_python_pyqt5() {
   if ! python_package_installed_verbose PyQt5.QtCore; then
      error "Missing python package PyQt5.QtCore"
   fi

   if ! python_package_installed_verbose PyQt5.QtWebKit; then
      error "Missing python package PyQt5.QtWebKit"
   fi

   if ! python_package_installed_verbose PyQt5.QtWebKitWidgets; then
      error "Missing python package PyQt5.QtWebKitWidgets"
   fi
}

# function to append information to config file
function add_config_info_python_pyqt5() {
  append_to_config_file "# python_pyqt5-${VERSION_python_pyqt5}: ${DESC_python_pyqt5}"
  append_to_config_file "export VERSION_python_pyqt5=${VERSION_python_pyqt5}"
}