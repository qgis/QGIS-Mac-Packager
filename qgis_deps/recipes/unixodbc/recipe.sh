#!/bin/bash

DESC_unixodbc="ODBC 3 connectivity for UNIX"

# version of your package
VERSION_unixodbc=2.3.9
LINK_unixodbc=libodbc.2.dylib
LINK_unixodbcinst=libodbcinst.2.dylib

# dependencies of this recipe
DEPS_unixodbc=(libtool)

# url of the package
URL_unixodbc=http://www.unixodbc.org/unixODBC-${VERSION_unixodbc}.tar.gz

# md5 of the package
MD5_unixodbc=06f76e034bb41df5233554abe961a16f

# default build path
BUILD_unixodbc=$BUILD_PATH/unixodbc/$(get_directory $URL_unixodbc)

# default recipe path
RECIPE_unixodbc=$RECIPES_PATH/unixodbc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_unixodbc() {
  cd $BUILD_unixodbc

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_unixodbc() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/unixodbc/lib/$LINK_unixodbc -nt $BUILD_unixodbc/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_unixodbc() {
  try rsync -a $BUILD_unixodbc/ $BUILD_PATH/unixodbc/build-$ARCH/
  try cd $BUILD_PATH/unixodbc/build-$ARCH
  push_env

  # includedir must be specific, since posgresql has
  # also similar include file names
  try ./configure \
    --prefix=$STAGE_PATH/unixodbc \
    --sysconfdir=$STAGE_PATH/unixodbc/etc \
    --disable-debug \
    --disable-dependency-tracking \
    --enable-gui=no

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_unixodbc() {
  verify_binary unixodbc/bin/odbcinst
  verify_binary unixodbc/lib/${LINK_unixodbc}
  verify_binary unixodbc/lib/$LINK_unixodbcinst
}

# function to append information to config file
function add_config_info_unixodbc() {
  append_to_config_file "# unixodbc-${VERSION_unixodbc}: ${DESC_unixodbc}"
  append_to_config_file "export VERSION_unixodbc=${VERSION_unixodbc}"
  append_to_config_file "export LINK_unixodbc=${LINK_unixodbc}"
  append_to_config_file "export LINK_unixodbcinst=$LINK_unixodbcinst"
}
