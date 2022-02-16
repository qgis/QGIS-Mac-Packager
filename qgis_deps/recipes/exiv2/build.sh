function build_exiv2() {
  try mkdir -p $BUILD_PATH/exiv2/build-$ARCH
  try cd $BUILD_PATH/exiv2/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_exiv2
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  pop_env
}
