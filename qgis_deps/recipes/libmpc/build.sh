function build_libmpc() {
  try cd $BUILD_PATH/libmpc/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-dependency-tracking \
      --with-gmp=$STAGE_PATH \
      --with-mpfr=$STAGE_PATH

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
