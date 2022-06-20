function build_exiv2() {
  try mkdir -p ${DEPS_BUILD_PATH}/exiv2/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/exiv2/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_exiv2

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env
}
