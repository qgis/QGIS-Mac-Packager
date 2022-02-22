function build_spatialite() {
  try cd ${DEPS_BUILD_PATH}/spatialite/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --enable-shared=yes \
    --enable-static=no \
    --enable-geocallbacks \
    --disable-dependency-tracking

  export CFLAGS="$CFLAGS -O2 -DPIC"

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
