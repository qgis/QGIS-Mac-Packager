function build_postgres() {
  try cd ${DEPS_BUILD_PATH}/postgres/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --with-ssl=openssl \
    --enable-rpath \
    --without-readline \
    --with-includes=${STAGE_PATH}/include \
    --without-zlib


  check_file_configuration config.status

  # client only install
  try $MAKE -C src/bin install
  try $MAKE -C src/include install
  try $MAKE -C src/interfaces install
  try $MAKE -C doc install

  pop_env
}
