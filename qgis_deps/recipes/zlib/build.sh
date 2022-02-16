function build_zlib() {
  try cd $BUILD_PATH/zlib/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
