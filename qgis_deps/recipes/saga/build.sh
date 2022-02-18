function build_saga() {
  try cd ${DEPS_BUILD_PATH}/saga/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-openmp \
    --disable-libfire \
    --enable-shared \
    --disable-gui \
    --disable-odbc \
    --with-postgresql=$STAGE_PATH/bin/pg_config

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}
