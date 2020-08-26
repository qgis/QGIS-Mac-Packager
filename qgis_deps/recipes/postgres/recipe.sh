#!/bin/bash

DESC_postgres="Postgres database"

# version of your package
VERSION_postgres=12.3

LINK_libpq=libpq.5.dylib

# dependencies of this recipe
DEPS_postgres=(openssl)

# url of the package
URL_postgres=https://ftp.postgresql.org/pub/source/v${VERSION_postgres}/postgresql-${VERSION_postgres}.tar.bz2

# md5 of the package
MD5_postgres=a30c023dd7088e44d73be71af2ef404a

# default build path
BUILD_postgres=$BUILD_PATH/postgres/$(get_directory $URL_postgres)

# default recipe path
RECIPE_postgres=$RECIPES_PATH/postgres

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_postgres() {
  cd $BUILD_postgres

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_postgres() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libpq -nt $BUILD_postgres/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_postgres() {
  try rsync -a $BUILD_postgres/ $BUILD_PATH/postgres/build-$ARCH/
  try cd $BUILD_PATH/postgres/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --enable-rpath \
    --with-openssl \
    --enable-static=no

  check_file_configuration config.status
  try $MAKESMP

  # client only install
  try $MAKE -C src/bin install
  try $MAKE -C src/include install
  try $MAKE -C src/interfaces install
  try $MAKE -C doc install

  pop_env
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