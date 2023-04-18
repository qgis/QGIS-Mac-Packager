#!/bin/bash

DESC_freetds="Libraries to talk to Microsoft SQL Server and Sybase databases"

# version of your package
VERSION_freetds=1.3.18
LINK_ct=libct.4.dylib
LINK_sybdb=libsybdb.5.dylib
LINK_tdsodbc=libtdsodbc.0.so

# dependencies of this recipe
DEPS_freetds=(gettext libtool openssl unixodbc)

# url of the package
URL_freetds=https://www.freetds.org/files/stable/freetds-${VERSION_freetds}.tar.gz

# md5 of the package
MD5_freetds=a54e09a32a33ca91d70a3501da86af31

# default build path
BUILD_freetds=$BUILD_PATH/freetds/$(get_directory $URL_freetds)

# default recipe path
RECIPE_freetds=$RECIPES_PATH/freetds

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freetds() {
  cd $BUILD_freetds

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_freetds() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_ct -nt $BUILD_freetds/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_freetds() {
  try rsync -a $BUILD_freetds/ $BUILD_PATH/freetds/build-$ARCH/
  try cd $BUILD_PATH/freetds/build-$ARCH
  push_env

  # add unixodbc
  export CFLAGS="$CFLAGS -I$STAGE_PATH/unixodbc/include"
  export LDFLAGS="$LDFLAGS -L$STAGE_PATH/unixodbc/lib"

  try ${CONFIGURE} \
      --with-tdsver=7.3 \
      --mandir=${STAGE_PATH}/man \
      --sysconfdir=${STAGE_PATH}/etc \
      --with-unixodbc-includes=${STAGE_PATH}/include/unixodbc \
      --with-openssl=${STAGE_PATH} \
      --enable-sybase-compat \
      --enable-krb5 \
      --enable-odbc-wide

  check_file_configuration config.status
  try $MAKE
  try $MAKE install

  # add freetds to unixodbc file
  UNIXODB_INI=$STAGE_PATH/unixodbc/etc/odbcinst.ini
  if ! grep -q FreeTDS "$UNIXODB_INI"; then
    echo "Patching $UNIXODB_INI with FreeTDS driver"
    echo "[FreeTDS]" >> $UNIXODB_INI
    echo "Description = FreeTDS Driver" >> $UNIXODB_INI
    echo "Driver = $STAGE_PATH/lib/libtdsodbc.so" >> $UNIXODB_INI
  fi
  pop_env
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
