function build_flex() {
  try cd $BUILD_PATH/flex/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --enable-shared \
    --disable-dependency-tracking

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
