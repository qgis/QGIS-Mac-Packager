function build_bison() {
  try cd $BUILD_PATH/bison/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-dependency-tracking

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
