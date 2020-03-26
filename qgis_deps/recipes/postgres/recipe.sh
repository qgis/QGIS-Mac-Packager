#!/bin/bash

# version of your package
VERSION_postgres=12.2

LINK_libpq_version=5
LINK_libpgtypes_version=3
LINK_libecpg_version=6

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

function patch_pg_linker_links() {
  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libpq.${LINK_libpq_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libpq.${LINK_libpq_version}.dylib does not exist... maybe you updated the postgres version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libpgtypes.${LINK_libpgtypes_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libpgtypes.${LINK_libpgtypes_version}.dylib does not exist... maybe you updated the postgres version?"
  fi
  if [ ! -f "${STAGE_PATH}/lib/libecpg.${LINK_libecpg_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libecpg.${LINK_libecpg_version}.dylib does not exist... maybe you updated the postgres version?"
  fi

  targets=(
    lib/libecpg.dylib
    lib/libecpg_compat.dylib
    lib/postgresql/libpqwalreceiver.so
    bin/pg_archivecleanup
    bin/pg_basebackup
    bin/pg_checksums
    bin/pg_config
    bin/pg_controldata
    bin/pg_ctl
    bin/pg_dump
    bin/pg_dumpall
    bin/pg_isready
    bin/pg_receivewal
    bin/pg_recvlogical
    bin/pg_resetwal
    bin/pg_restore
    bin/pg_rewind
    bin/pg_test_fsync
    bin/pg_test_timing
    bin/pg_upgrade
    bin/pg_waldump
    bin/pgbench
    bin/ecpg
    bin/createuser
    bin/initdb
    bin/createdb
    bin/reindexdb
    bin/dropdb
    bin/psql
    bin/clusterdb
    bin/postgres
    bin/dropuser
    bin/vacuumdb
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libpq.${LINK_libpq_version}.dylib" "@rpath/libpq.${LINK_libpq_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libpgtypes.${LINK_libpgtypes_version}.dylib" "@rpath/libpgtypes.${LINK_libpgtypes_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libecpg.${LINK_libecpg_version}.dylib" "@rpath/libecpg.${LINK_libecpg_version}.dylib"  ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}


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

  try ${CONFIGURE} \
    --disable-debug \
    --enable-rpath

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  # Change install names
  install_name_tool -id "@rpath/libpq.dylib" ${STAGE_PATH}/lib/libpq.dylib
  install_name_tool -id "@rpath/libpgtypes.dylib" ${STAGE_PATH}/lib/libpgtypes.dylib
  install_name_tool -id "@rpath/libecpg.dylib" ${STAGE_PATH}/lib/libecpg.dylib
  install_name_tool -id "@rpath/libecpg_compat.dylib" ${STAGE_PATH}/lib/libecpg_compat.dylib
  install_name_tool -id "@rpath/libpqwalreceiver.so" ${STAGE_PATH}/lib/postgresql/libpqwalreceiver.so

  patch_pg_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_postgres() {
  verify_lib libpq.dylib
  verify_lib libpgtypes.dylib
  verify_lib libecpg.dylib
  verify_lib libecpg_compat.dylib
  verify_lib postgresql/libpqwalreceiver.so

  verify_bin pg_rewind
}
