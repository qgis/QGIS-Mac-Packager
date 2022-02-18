function build_little_cms2() {
  try cd ${DEPS_BUILD_PATH}/little_cms2/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug --disable-dependency-tracking

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}
