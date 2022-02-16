function build_libtool() {
  try cd $BUILD_PATH/libtool/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --program-prefix=g \
    --enable-ltdl-install

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
