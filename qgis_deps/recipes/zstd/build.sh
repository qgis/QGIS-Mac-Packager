function build_zstd() {
  try cd ${DEPS_BUILD_PATH}/zstd/build-$ARCH
  push_env

  try $MAKE install PREFIX=$STAGE_PATH

  pop_env
}
