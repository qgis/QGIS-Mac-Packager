function build_freetype() {
  try cd $BUILD_PATH/freetype/build-$ARCH

  push_env

  try ${CONFIGURE} --disable-debug --without-harfbuzz

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
