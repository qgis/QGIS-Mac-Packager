function build_webp() {
  try cd $BUILD_PATH/webp/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
