#!/bin/bash

DESC_qtextra="Build of some extra QT plugins"


# full link version of the library
LINK_libqsqlodbc=libqsqlodbc.dylib
LINK_libqsqlpsql=libqsqlpsql.dylib

DEPS_qtextra=(sqlite unixodbc postgres)


# md5 of the package

# default build path
BUILD_qtextra=${DEPS_BUILD_PATH}/qtextra/$(get_directory $URL_qtextra)

# default recipe path
RECIPE_qtextra=$RECIPES_PATH/qtextra

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtextra() {
  cd $BUILD_qtextra
  try rsync -a $BUILD_qtextra/ ${DEPS_BUILD_PATH}/qtextra/build-${ARCH}


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
