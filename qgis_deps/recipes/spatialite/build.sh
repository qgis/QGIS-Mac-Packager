function build_spatialite() {
  try cd $BUILD_PATH/spatialite/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --enable-geocallbacks \
    --disable-dependency-tracking

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
