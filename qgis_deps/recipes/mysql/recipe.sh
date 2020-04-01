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

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mysql() {
  cd $BUILD_mysql

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
      -DWITHOUT_SERVER=ON \
      -DFORCE_INSOURCE_BUILD=1 \
      -ENABLED_PROFILING=OFF \
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

  try $MAKESMP
  try $MAKE install
  try rm -rf $STAGE_PATH/mysql-test
  try rm -f $STAGE_PATH/LICENCE
  try rm -f $STAGE_PATH/README
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