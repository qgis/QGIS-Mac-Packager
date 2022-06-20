#!/bin/bash

DESC_sqlite="Portable Foreign Function Interface library"


LINK_sqlite=libsqlite3.0.dylib

DEPS_sqlite=()

# default build path
BUILD_sqlite=${DEPS_BUILD_PATH}/sqlite/$(get_directory $URL_sqlite)

# default recipe path
RECIPE_sqlite=$RECIPES_PATH/sqlite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_sqlite() {
  cd $BUILD_sqlite
    patch_configure_file configure
  try rsync  -a $BUILD_sqlite/ ${DEPS_BUILD_PATH}/sqlite/build-${ARCH}

}

# function called after all the compile have been done
function postbuild_sqlite() {
  verify_binary lib/$LINK_sqlite
}

# function to append information to config file
function add_config_info_sqlite() {
  append_to_config_file "# sqlite-${VERSION_sqlite}: ${DESC_sqlite}"
  append_to_config_file "export VERSION_sqlite=${VERSION_sqlite}"
  append_to_config_file "export LINK_sqlite=${LINK_sqlite}"
}
