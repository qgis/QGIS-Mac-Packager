function build_mpfr() {
  try cd $BUILD_PATH/mpfr/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-silent-rules

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
