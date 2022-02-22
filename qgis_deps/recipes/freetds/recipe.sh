#!/bin/bash

DESC_freetds="Libraries to talk to Microsoft SQL Server and Sybase databases"

LINK_ct=libct.4.dylib
LINK_sybdb=libsybdb.5.dylib
LINK_tdsodbc=libtdsodbc.0.so

DEPS_freetds=(gettext libtool openssl unixodbc)


# md5 of the package

# default build path
BUILD_freetds=${DEPS_BUILD_PATH}/freetds/$(get_directory $URL_freetds)

# default recipe path
RECIPE_freetds=$RECIPES_PATH/freetds

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freetds() {
  cd $BUILD_freetds
    patch_configure_file configure
  try rsync  -a $BUILD_freetds/ ${DEPS_BUILD_PATH}/freetds/build-${ARCH}

}

function shouldbuild_freetds() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_ct -nt $BUILD_freetds/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_freetds() {
  verify_binary bin/tsql
  verify_binary bin/freebcp
  verify_binary bin/bsqldb
  verify_binary bin/defncopy
  verify_binary bin/datacopy
  verify_binary bin/bsqlodbc
  verify_binary lib/$LINK_ct
  verify_binary lib/$LINK_sybdb
  verify_binary lib/$LINK_tdsodbc
}

# function to append information to config file
function add_config_info_freetds() {
  append_to_config_file "# freetds-${VERSION_freetds}: ${DESC_freetds}"
  append_to_config_file "export VERSION_freetds=${VERSION_freetds}"
  append_to_config_file "export LINK_ct=${LINK_ct}"
  append_to_config_file "export LINK_sybdb=${LINK_sybdb}"
  append_to_config_file "export LINK_tdsodbc=${LINK_tdsodbc}"
}
