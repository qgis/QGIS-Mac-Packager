function build_unixodbc() {
  try cd ${DEPS_BUILD_PATH}/unixodbc/build-$ARCH
  push_env

  # includedir must be specific, since posgresql has
  # also similar include file names
  try ./configure \
    --prefix=$STAGE_PATH/unixodbc \
    --sysconfdir=$STAGE_PATH/unixodbc/etc \
    --disable-debug \
    --disable-dependency-tracking \
    --enable-gui=no

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
