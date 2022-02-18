function build_libffi() {
  try cd ${DEPS_BUILD_PATH}/libffi/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --enable-static=no

  check_file_configuration config.status
  try $MAKESMP
  try $MAKE install

  pop_env
}
