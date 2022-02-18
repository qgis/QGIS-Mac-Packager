function build_postgres() {
  try cd ${DEPS_BUILD_PATH}/postgres/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --enable-rpath \
    --with-openssl

  check_file_configuration config.status
  try $MAKESMP

  # client only install
  try $MAKE -C src/bin install
  try $MAKE -C src/include install
  try $MAKE -C src/interfaces install
  try $MAKE -C doc install

  pop_env
}
