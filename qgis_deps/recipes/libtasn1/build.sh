function build_libtasn1() {
  try cd $BUILD_PATH/libtasn1/build-$ARCH
  push_env

  patch_configure_file configure

  export CFLAGS="$CFLAGS -O2 -DPIC"
  export PKG_CONFIG=${PKG_CONFIG_PATH}

  try ${CONFIGURE} --disable-static --disable-doc

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
