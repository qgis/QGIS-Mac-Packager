function build_libssh2() {
  try cd $BUILD_PATH/libssh2/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-debug \
      --disable-dependency-tracking \
      --disable-silent-rules \
      --disable-examples-build \
      --with-openssl \
      --with-libz \
      --with-libssl-prefix=${STAGE_PATH}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
