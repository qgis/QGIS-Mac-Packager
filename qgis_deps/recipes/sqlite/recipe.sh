#!/bin/bash

DESC_sqlite="Portable Foreign Function Interface library"

# version of your package
VERSION_sqlite=3.31.1

# dependencies of this recipe
DEPS_sqlite=()

# url of the package
URL_sqlite=https://sqlite.org/2020/sqlite-autoconf-3310100.tar.gz

# md5 of the package
MD5_sqlite=2d0a553534c521504e3ac3ad3b90f125

# default build path
BUILD_sqlite=$BUILD_PATH/sqlite/$(get_directory $URL_sqlite)

# default recipe path
RECIPE_sqlite=$RECIPES_PATH/sqlite

patch_sqlite_linker_links () {
  install_name_tool -id "@rpath/libsqlite3.dylib" ${STAGE_PATH}/lib/libsqlite3.dylib

  targets=(
    bin/sqlite3
  )

  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_sqlite() {
  cd $BUILD_sqlite

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_sqlite() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libsqlite3.dylib -nt $BUILD_sqlite/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_sqlite() {
  try rsync -a $BUILD_sqlite/ $BUILD_PATH/sqlite/build-$ARCH/
  try cd $BUILD_PATH/sqlite/build-$ARCH
  push_env

  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
  export CPPFLAGS="$CPPFLAGS -DSQLITE_MAX_VARIABLE_NUMBER=250000"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_RTREE=1"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_JSON1=1"

  try ${CONFIGURE} \
    --disable-debug \
    --disable-dependency-tracking \
    --enable-dynamic-extensions \
    --enable-readline \
    --disable-editline \
    --enable-session

  check_file_configuration config.status
  try $MAKESMP
  try $MAKE install

  patch_sqlite_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_sqlite() {
  verify_lib "libsqlite3.dylib"
}

# function to append information to config file
function add_config_info_sqlite() {
  append_to_config_file "# sqlite-${VERSION_sqlite}: ${DESC_sqlite}"
  append_to_config_file "export VERSION_sqlite=${VERSION_sqlite}"
}
