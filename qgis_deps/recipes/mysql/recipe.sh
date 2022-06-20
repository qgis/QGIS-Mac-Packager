#!/bin/bash

DESC_mysql="Open source relational database management system"

LINK_libmysqlclient=libmysqlclient.21.dylib

DEPS_mysql=(openssl protobuf boost zstd zlib)

# default build path
BUILD_mysql=${DEPS_BUILD_PATH}/mysql/$(get_directory $URL_mysql)

# default recipe path
RECIPE_mysql=$RECIPES_PATH/mysql

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mysql() {
  cd $BUILD_mysql
}

# function called after all the compile have been done
function postbuild_mysql() {
  verify_binary lib/$LINK_libmysqlclient
}

# function to append information to config file
function add_config_info_mysql() {
  append_to_config_file "# mysql-${VERSION_mysql}: ${DESC_mysql}"
  append_to_config_file "export VERSION_mysql=${VERSION_mysql}"
  append_to_config_file "export LINK_libmysqlclient=${LINK_libmysqlclient}"
}