#!/bin/bash

DESC_sqlite="Portable Foreign Function Interface library"

# version of your package
VERSION_sqlite_MAJOR=3
VERSION_sqlite_MINOR=37
VERSION_sqlite_PATCH=2
VERSION_sqlite=${VERSION_sqlite_MAJOR}.${VERSION_sqlite_MINOR}.${VERSION_sqlite_PATCH}
LINK_sqlite=libsqlite3.0.dylib

# dependencies of this recipe
DEPS_sqlite=()

# url of the package
URL_sqlite_BASE=$(printf "%d%02d%02d00" $VERSION_sqlite_MAJOR $VERSION_sqlite_MINOR $VERSION_sqlite_PATCH)
URL_sqlite=https://sqlite.org/2022/sqlite-autoconf-${URL_sqlite_BASE}.tar.gz

# md5 of the package
MD5_sqlite=683cc5312ee74e71079c14d24b7a6d27

# default build path
BUILD_sqlite=$BUILD_PATH/sqlite/$(get_directory $URL_sqlite)

# default recipe path
RECIPE_sqlite=$RECIPES_PATH/sqlite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_sqlite() {
  cd $BUILD_sqlite
    patch_configure_file configure
  try rsync  -a $BUILD_sqlite/ ${BUILD_PATH}/sqlite/build-${ARCH}

}

function shouldbuild_sqlite() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_sqlite -nt $BUILD_sqlite/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_sqlite() {
  verify_binary lib/$LINK_sqlite
}

# function to append information to config file
function add_config_info_sqlite() {
  append_to_config_file "# sqlite-${VERSION_sqlite}: ${DESC_sqlite}"
  append_to_config_file "export VERSION_sqlite=${VERSION_sqlite}"
  append_to_config_file "export LINK_sqlite=${LINK_sqlite}"
}
