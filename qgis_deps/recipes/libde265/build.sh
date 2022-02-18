function build_libde265() {
  try cd $BUILD_PATH/libde265/build-$ARCH
  push_env

  try ./autogen.sh
  patch_configure_file configure
  try ${CONFIGURE} --disable-debug --disable-dependency-tracking \
    --enable-shared=yes \
    --enable-static=no \
    --disable-dec265 \
    --disable-sherlock265

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
