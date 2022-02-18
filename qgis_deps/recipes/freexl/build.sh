function build_freexl() {
  try cd ${DEPS_BUILD_PATH}/freexl/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
