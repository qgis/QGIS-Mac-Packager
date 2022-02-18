function build_libisl() {
  try cd ${DEPS_BUILD_PATH}/libisl/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug --disable-dependency-tracking

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
