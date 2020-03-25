#!/bin/bash

# version of your package
# keep in SYNC with qscintilla receipt
VERSION_python_qscintilla=2.11.4

# dependencies of this recipe
# depends on PyQt5
DEPS_python_qscintilla=(qscintilla python_sip python_pyqt5)

# url of the package
URL_python_qscintilla=https://www.riverbankcomputing.com/static/Downloads/QScintilla/${VERSION_python_qscintilla}/QScintilla-${VERSION_python_qscintilla}.tar.gz

# md5 of the package
MD5_python_qscintilla=d750d9143b0697df2e4662cea3efd20d

# default build path
BUILD_python_qscintilla=$BUILD_PATH/python_qscintilla/$(get_directory $URL_python_qscintilla)

# default recipe path
RECIPE_python_qscintilla=$RECIPES_PATH/python_qscintilla

patch_qscintilla_linker_links () {
  targets=(
    lib/python3.7/site-packages/PyQt5/Qsci.so
  )

  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @loader_path/../../../ ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_qscintilla() {
  cd $BUILD_python_qscintilla

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_qscintilla() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed PyQt5.Qsci; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_qscintilla() {
  try rsync -a $BUILD_python_qscintilla/ $BUILD_PATH/python_qscintilla/build-$ARCH/
  try cd $BUILD_PATH/python_qscintilla/build-$ARCH
  push_env

  # build python
  cd Python
  mkdir -p ${STAGE_PATH}/share/sip/PyQt5/Qsci

   if ! python_package_installed PyQt5.QtCore; then
      error "Missing python package PyQt5.QtCore"
   fi

  QMAKEFEATURES=$STAGE_PATH/data/mkspecs/features;\
  try $PYCONFIGURE \
    -o ${STAGE_PATH}/lib \
    -n ${STAGE_PATH}/include \
    --apidir=${STAGE_PATH}/qsci \
    --stubsdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --destdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --qsci-sipdir=${STAGE_PATH}/share/sip/PyQt5 \
    --qsci-incdir=${STAGE_PATH}/include \
    --qsci-libdir=${STAGE_PATH}/lib \
    --pyqt=PyQt5 \
    --pyqt-sipdir=${STAGE_PATH}/share/sip/PyQt5 \
    --sip-incdir=${STAGE_PATH}/include \
    --spec=${QSPEC} \
    --verbose

  try $MAKESMP
  try $MAKE install
  try $MAKE clean

  patch_qscintilla_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_python_qscintilla() {
   if ! python_package_installed PyQt5.Qsci; then
      error "Missing python package qsci"
   fi
}
