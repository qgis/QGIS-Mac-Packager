#!/bin/bash

DESC_python_qscintilla="QScintilla package for python"

# keep in SYNC with qscintilla receipt

# depends on PyQt5
DEPS_python_qscintilla=(python qscintilla python_sip python_pyqt5 python_packages)

# default build path
BUILD_python_qscintilla=${DEPS_BUILD_PATH}/python_qscintilla/$(get_directory $URL_python_qscintilla)

# default recipe path
RECIPE_python_qscintilla=$RECIPES_PATH/python_qscintilla

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_qscintilla() {
  cd $BUILD_python_qscintilla
  try rsync -a $BUILD_python_qscintilla/ ${DEPS_BUILD_PATH}/python_qscintilla/build-${ARCH}

  # without QtWidgets it cannot compile with
  # fatal error: 'QAbstractScrollArea' file not found
  # try ${SED} "s;# Work around QTBUG-39300.;pro.write('QT += widgets printsupport\\\n');g" Python/configure.py
}

# function called after all the compile have been done
function postbuild_python_qscintilla() {
   if ! python_package_installed_verbose PyQt5.Qsci; then
      error "Missing python package qsci"
   fi
}

# function to append information to config file
function add_config_info_python_qscintilla() {
  append_to_config_file "# python_qscintilla-${VERSION_python_qscintilla}: ${DESC_python_qscintilla}"
  append_to_config_file "export VERSION_python_qscintilla=${VERSION_python_qscintilla}"
}