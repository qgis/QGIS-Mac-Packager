#!/bin/bash

DESC_postgres="Postgres database"

LINK_libpq=libpq.5.dylib

DEPS_postgres=(openssl)


# default build path
BUILD_postgres=${DEPS_BUILD_PATH}/postgres/$(get_directory $URL_postgres)

# default recipe path
RECIPE_postgres=$RECIPES_PATH/postgres

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_postgres() {
  cd $BUILD_postgres
  patch_configure_file configure
  try rsync  -a $BUILD_postgres/ ${DEPS_BUILD_PATH}/postgres/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_postgres() {
  verify_binary lib/$LINK_libpq

  verify_binary lib/libpgtypes.dylib
  verify_binary lib/libecpg.dylib
  verify_binary lib/libecpg_compat.dylib

  verify_binary bin/pg_rewind
}

# function to append information to config file
function add_config_info_postgres() {
  append_to_config_file "# postgres-${VERSION_postgres}: ${DESC_postgres}"
  append_to_config_file "export VERSION_postgres=${VERSION_postgres}"
  append_to_config_file "export LINK_libpq=${LINK_libpq}"
}