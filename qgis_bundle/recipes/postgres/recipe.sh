#!/bin/bash

function check_postgres() {
  env_var_exists VERSION_postgres
}

function bundle_postgres() {
    : # install_name_tool -id "@rpath/libpostgres.dylib" ${STAGE_PATH}/lib/libpostgres.dylib
}

function postbundle_postgres() {
    :
}

function add_config_info_postgres() {
    :
}

function patch_postgres_linker_links() {
  # Change install names
  install_name_tool -id "@rpath/libpq.dylib" ${STAGE_PATH}/lib/libpq.dylib
  install_name_tool -id "@rpath/libpgtypes.dylib" ${STAGE_PATH}/lib/libpgtypes.dylib
  install_name_tool -id "@rpath/libecpg.dylib" ${STAGE_PATH}/lib/libecpg.dylib
  install_name_tool -id "@rpath/libecpg_compat.dylib" ${STAGE_PATH}/lib/libecpg_compat.dylib
  install_name_tool -id "@rpath/libpqwalreceiver.so" ${STAGE_PATH}/lib/postgresql/libpqwalreceiver.so

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
    if [ ! -f ${STAGE_PATH}/$i ]; then
      echo "missing $i"
    fi

    install_name_tool -change "${STAGE_PATH}/lib/libpq.${LINK_libpq_version}.dylib" "@rpath/libpq.${LINK_libpq_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libpgtypes.${LINK_libpgtypes_version}.dylib" "@rpath/libpgtypes.${LINK_libpgtypes_version}.dylib" ${STAGE_PATH}/$i
    install_name_tool -change "${STAGE_PATH}/lib/libecpg.${LINK_libecpg_version}.dylib" "@rpath/libecpg.${LINK_libecpg_version}.dylib"  ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}
