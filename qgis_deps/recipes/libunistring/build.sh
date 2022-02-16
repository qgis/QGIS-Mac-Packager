function build_libunistring() {
  try cd $BUILD_PATH/libunistring/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --enable-shared=yes \
    --enable-static=no \
    --disable-dependency-tracking \
    --disable-silent-rules

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
