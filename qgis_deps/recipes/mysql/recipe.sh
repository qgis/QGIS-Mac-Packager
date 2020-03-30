#!/bin/bash

DESC_mysql="Open source relational database management system"

# version of your package
VERSION_mysql=8.0.19
LINK_mysql_version=21

# dependencies of this recipe
DEPS_mysql=(openssl protobuf boost zstd zlib)

# url of the package
URL_mysql=https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-${VERSION_mysql}.tar.gz

# md5 of the package
MD5_mysql=1e42b9bd431059430c7617f24608609a

# default build path
BUILD_mysql=$BUILD_PATH/mysql/$(get_directory $URL_mysql)

# default recipe path
RECIPE_mysql=$RECIPES_PATH/mysql

function patch_mysql_linker_links() {
  targets=(
    bin/comp_err
    bin/ibd2sdi
    bin/innochecksum
    bin/lz4_decompress
    bin/my_print_defaults
    bin/myisam_ftdump
    bin/myisamchk
    bin/myisamlog
    bin/myisampack
    bin/mysql
    bin/mysql_client_test
    bin/mysql_config
    bin/mysql_config_editor
    bin/mysql_secure_installation
    bin/mysql_ssl_rsa_setup
    bin/mysql_tzinfo_to_sql
    bin/mysql_upgrade
    bin/mysqladmin
    bin/mysqlbinlog
    bin/mysqlcheck
    bin/mysqld
    bin/mysqld_multi
    bin/mysqld_safe
    bin/mysqldump
    bin/mysqldumpslow
    bin/mysqlimport
    bin/mysqlpump
    bin/mysqlrouter
    bin/mysqlrouter_keyring
    bin/mysqlrouter_passwd
    bin/mysqlrouter_plugin_info
    bin/mysqlshow
    bin/mysqlslap
    bin/mysqltest
    bin/mysqltest_safe_process
    bin/mysqlxtest
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

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mysql() {
  cd $BUILD_mysql

  patch_mysql_linker_links

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_mysql() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libmysqlclient.dylib -nt $BUILD_mysql/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_mysql() {
  try mkdir -p $BUILD_PATH/mysql/build-$ARCH
  try cd $BUILD_PATH/mysql/build-$ARCH
  try mkdir -p downloaded_boost
  push_env

  # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
  try ${CMAKE}  \
      -DFORCE_INSOURCE_BUILD=1 \
      -DCOMPILATION_COMMENT=qgis_deps \
      -DINSTALL_DOCDIR=share/doc/mysql \
      -DINSTALL_INCLUDEDIR=include/mysql \
      -DINSTALL_INFODIR=share/info \
      -DINSTALL_MANDIR=share/man \
      -DINSTALL_MYSQLSHAREDIR=share/mysql \
      -DINSTALL_SUPPORTFILESDIR=mysql/support-files \
      -DINSTALL_PLUGINDIR=lib/plugin \
      -DMYSQL_DATADIR=$STAGE_PATH/share/data \
      -DDOWNLOAD_BOOST=OFF \
      -DWITH_BOOST=system \
      -DWITH_CURL=NO \
      -DWITH_ZSTD=system \
      -DWITH_SYSTEM_LIBS_DEFAULT=TRUE \
      -DCMAKE_FIND_FRAMEWORK=LAST \
      -DWITH_EDITLINE=system \
      -DWITH_SSL=$STAGE_PATH \
      -DWITH_PROTOBUF=system \
      -DWITH_UNIT_TESTS=OFF \
      -DDEFAULT_CHARSET=utf8 \
      -DDEFAULT_COLLATION=utf8_general_ci \
      -DENABLED_LOCAL_INFILE=1 \
      -DWITH_INNODB_MEMCACHED=ON \
      $BUILD_mysql

  check_file_configuration CMakeCache.txt

  targets=(
    xprotocol_plugin
    comp_client_err
    comp_err
  )

  # hack a bit RPATH, since the output dir is added
  # and some binaries are called during build of other
  # targets
  try mkdir -p library_output_directory/
  try ln -sF "$STAGE_PATH/lib/libzstd.dylib" "library_output_directory/libzstd.dylib"

  try mkdir -p runtime_output_directory/
  try ln -sF "$STAGE_PATH/lib/libzstd.dylib" "runtime_output_directory/libzstd.dylib"

  # build binaries that are run during build time for other targets
  # and fix their rpath to be able to load libs from stage lib dir
  for i in ${targets[*]}
  do
      try $MAKESMP $i
      install_name_tool -add_rpath $STAGE_PATH/lib runtime_output_directory/$i
  done

  try $MAKESMP
  try $MAKE install

  rm -rf $STAGE_PATH/mysql-test

  patch_mysql_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_mysql() {
  verify_lib "libmysqlclient.dylib"
}

# function to append information to config file
function add_config_info_mysql() {
  append_to_config_file "# mysql-${VERSION_mysql}: ${DESC_mysql}"
  append_to_config_file "export VERSION_mysql=${VERSION_mysql}"
}