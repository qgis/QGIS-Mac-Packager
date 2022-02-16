function build_rttopo() {
  try cd $BUILD_PATH/rttopo/build-$ARCH
  push_env

  try ./autogen.sh
  patch_configure_file configure

  try ${CONFIGURE} \
    --enable-geocallbacks \
    --disable-dependency-tracking

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
