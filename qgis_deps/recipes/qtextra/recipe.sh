#!/bin/bash

DESC_qtextra="Build of some extra QT plugins"

# version of your package
VERSION_qtextra=$VERSION_QT

# full link version of the library
LINK_libqsqlodbc=libqsqlodbc.dylib
LINK_libqsqlpsql=libqsqlpsql.dylib

# dependencies of this recipe
DEPS_qtextra=(sqlite unixodbc postgres)

# url of the package
URL_qtextra=https://github.com/qt/qtbase/archive/v${VERSION_qtextra}.tar.gz

# md5 of the package
MD5_qtextra=8b6bcfa8eb124e7c36b824d04f7c068e

# default build path
BUILD_qtextra=$BUILD_PATH/qtextra/$(get_directory $URL_qtextra)

# default recipe path
RECIPE_qtextra=$RECIPES_PATH/qtextra

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtextra() {
  cd $BUILD_qtextra

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qtextra() {
  # If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/qt5/plugins/sqldrivers/${LINK_libqtextra2_qt5}" -nt $BUILD_qtextra/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qtextra() {
  try rsync -a $BUILD_qtextra/ $BUILD_PATH/qtextra/build-$ARCH/
  try cd $BUILD_PATH/qtextra/build-$ARCH
  push_env

  # Check https://doc.qt.io/qt-5/sql-driver.html for available drivers
  # sqlite3 is already shipped with Qt
  # note that the plugins will not be useful in developer mode (building QGIS)
  # , since they are not in <QT>/clang_64/plugins directory.
  # make a symbolic link if you want to use it in the dev mode
  try mkdir -p ${STAGE_PATH}/qt5/plugins/sqldrivers

  cd src/plugins/sqldrivers/
  try ${SED} 's;-liodbc;-lodbc;g' configure.json
  rm -f config.cache

  try ${QMAKE} -- \
    ODBC_PREFIX=$STAGE_PATH/unixodbc \
    PSQL_INCDIR=$STAGE_PATH/include \
    PSQL_LIBDIR=$STAGE_PATH/lib

  try $MAKE sub-odbc
  try cp plugins/sqldrivers/libqsqlodbc.dylib ${STAGE_PATH}/qt5/plugins/sqldrivers/

  try $MAKESMP sub-psql
  try cp plugins/sqldrivers/libqsqlpsql.dylib ${STAGE_PATH}/qt5/plugins/sqldrivers/

  pop_env
}

# function called after all the compile have been done
function postbuild_qtextra() {
  verify_binary qt5/plugins/sqldrivers/$LINK_libqsqlodbc
  verify_binary qt5/plugins/sqldrivers/$LINK_libqsqlpsql
}

# function to append information to config file
function add_config_info_qtextra() {
  append_to_config_file "# qtextra-${VERSION_qtextra}: ${DESC_qtextra}"
  append_to_config_file "export VERSION_qtextra=${VERSION_qtextra}"
  append_to_config_file "export LINK_libqsqlodbc=${LINK_libqsqlodbc}"
  append_to_config_file "export LINK_libqsqlpsql=${LINK_libqsqlpsql}"
}
