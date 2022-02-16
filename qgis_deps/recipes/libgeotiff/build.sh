function build_libgeotiff() {
  try mkdir -p $BUILD_PATH/libgeotiff/build-$ARCH
  try cd $BUILD_PATH/libgeotiff/build-$ARCH

  push_env

  # TODO why this is only static library!??
  try $CMAKE $BUILD_libgeotiff .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  pop_env
}
