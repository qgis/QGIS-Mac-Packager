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
  try rsync -a $BUILD_qtextra/ ${BUILD_PATH}/qtextra/build-${ARCH}


}

function shouldbuild_qtextra() {
  # If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/qt5/plugins/sqldrivers/${LINK_libqtextra2_qt5}" -nt $BUILD_qtextra/.patched ]; then
    DO_BUILD=0
  fi
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
