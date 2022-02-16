function build_gettext() {
  try cd $BUILD_PATH/gettext/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --disable-static \
    --disable-java \
    --program-prefix=g

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
