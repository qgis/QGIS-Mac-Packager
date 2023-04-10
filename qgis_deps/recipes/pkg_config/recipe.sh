#!/bin/bash

DESC_pkg_config="Manage compile and link flags for libraries"

# version of your package
VERSION_pkg_config=0.29.2

# dependencies of this recipe
DEPS_pkg_config=()

# url of the package
URL_pkg_config=https://pkgconfig.freedesktop.org/releases/pkg-config-${VERSION_pkg_config}.tar.gz

# md5 of the package
MD5_pkg_config=f6e931e319531b736fadc017f470e68a

# default build path
BUILD_pkg_config=$BUILD_PATH/pkg_config/$(get_directory $URL_pkg_config)

# default recipe path
RECIPE_pkg_config=$RECIPES_PATH/pkg_config

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_pkg_config() {
  cd $BUILD_pkg_config

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_pkg_config() {
  # If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/bin/pkg-config" -nt $BUILD_pkg_config/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_pkg_config() {
  try rsync -a $BUILD_pkg_config/ $BUILD_PATH/pkg_config/build-$ARCH/
  try cd $BUILD_PATH/pkg_config/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --with-internal-glib \
    --disable-host-tool \
    --with-pc-path=${STAGE_PATH}/lib/pkgconfig \
    --with-system-include-path=/usr/include

  check_file_configuration config.status
  try $MAKESMP

  # client only install
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_pkg_config() {
  verify_binary bin/pkg-config
}

# function to append information to config file
function add_config_info_pkg_config() {
  append_to_config_file "# pkg-config-${VERSION_pkg_config}: ${DESC_pkg_config}"
  append_to_config_file "export VERSION_postgres=${VERSION_pkg_config}"
}