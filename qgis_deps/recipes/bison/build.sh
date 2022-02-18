function build_bison() {
  try cd ${DEPS_BUILD_PATH}/bison/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-dependency-tracking

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}
