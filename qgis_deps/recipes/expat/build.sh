function build_expat() {
  try cd $BUILD_PATH/expat/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
