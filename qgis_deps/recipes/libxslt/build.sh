function build_libxslt() {
  try cd ${DEPS_BUILD_PATH}/libxslt/build-$ARCH
  push_env

  patch_configure_file configure

  try ${CONFIGURE} \
    --enable-silent-rules \
    --with-debugger=off \
    --disable-dependency-tracking \
    --without-python

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
