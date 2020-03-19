#!/bin/bash

# version of your package
VERSION_postgres=12.2

# dependencies of this recipe
DEPS_postgres=()

# url of the package
URL_postgres=https://ftp.postgresql.org/pub/source/v${VERSION_postgres}/postgresql-${VERSION_postgres}.tar.bz2

# md5 of the package
MD5_postgres=a88ceea8ecf2741307f663e4539b58b7

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
  if [ ${STAGE_PATH}/lib/libpq.dylib -nt $BUILD_postgres/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_postgres() {
  try rsync -a $BUILD_postgres/ $BUILD_PATH/postgres/build-$ARCH/
  try cd $BUILD_PATH/postgres/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_postgres() {
  verify_lib "${STAGE_PATH}/lib/libpq.dylib"
}
