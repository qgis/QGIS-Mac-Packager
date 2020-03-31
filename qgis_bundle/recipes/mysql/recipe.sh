#!/bin/bash

function check_mysql() {
  env_var_exists VERSION_mysql
}

function bundle_mysql() {
    : # install_name_tool -id "@rpath/libmysql.dylib" ${STAGE_PATH}/lib/libmysql.dylib
}

function postbundle_mysql() {
    :
}

function add_config_info_mysql() {
    :
}

function patch_mysql_linker_links() {

# server-only
# REMOVE ME
# bin/mysqlxtest
# bin/mysqltest_safe_process
#     bin/mysqlrouter
#    bin/mysqlrouter_keyring
#    bin/mysqlrouter_passwd
#    bin/mysqlrouter_plugin_info
#  bin/mysqldumpslow
#     bin/mysqld
#    bin/mysqld_multi
#    bin/mysqld_safe
#
#     bin/mysql_tzinfo_to_sql
# bin/ibd2sdi

# bin/innochecksum
# mysql_upgrade
# bin/mysql_client_test
#     bin/myisam_ftdump
#    bin/myisamchk
#    bin/myisamlog
#    bin/myisampack

# not binary
# bin/mysql_config

  targets=(
    bin/comp_err
    bin/mysqldump
    bin/lz4_decompress
    bin/my_print_defaults
    bin/mysql
    bin/mysql_config_editor
    bin/mysql_secure_installation
    bin/mysql_ssl_rsa_setup
    bin/mysqladmin
    bin/mysqlbinlog
    bin/mysqlcheck
    bin/mysqlimport
    bin/mysqlpump
    bin/mysqlshow
    bin/mysqlslap
    bin/mysqltest
    bin/perror
    bin/zlib_decompress
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/mysql/build-$ARCH/library_output_directory/. ${STAGE_PATH}/$i
      install_name_tool -delete_rpath $BUILD_PATH/mysql/build-$ARCH/library_output_directory ${STAGE_PATH}/$i
      install_name_tool -delete_rpath $BUILD_PATH/mysql/build-$ARCH/runtime_output_directory/. ${STAGE_PATH}/$i
      install_name_tool -delete_rpath $STAGE_PATH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
