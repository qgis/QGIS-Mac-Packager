#!/bin/bash

DESC_mysql="Open source relational database management system"

# version of your package
VERSION_mysql=8.0.28
LINK_libmysqlclient=libmysqlclient.21.dylib

# dependencies of this recipe
DEPS_mysql=(openssl protobuf boost zstd zlib)

# url of the package
URL_mysql=https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-${VERSION_mysql}.tar.gz

# md5 of the package
MD5_mysql=362b8141ecaf425b803fe55292e2df98

# default build path
BUILD_mysql=$BUILD_PATH/mysql/$(get_directory $URL_mysql)

# default recipe path
RECIPE_mysql=$RECIPES_PATH/mysql

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mysql() {
  cd $BUILD_mysql


}

function shouldbuild_mysql() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libmysqlclient -nt $BUILD_mysql/.patched ]; then
    DO_BUILD=0
  fi
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