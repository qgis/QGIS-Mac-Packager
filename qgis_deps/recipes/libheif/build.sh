function build_libheif() {
  try cd $BUILD_PATH/libheif/build-$ARCH
  push_env

  try ./autogen.sh
  patch_configure_file configure
  try ${CONFIGURE} --disable-debug --disable-dependency-tracking \
  --enable-shared=yes \
  --enable-static=no \
  --disable-gdk-pixbuf \
  --disable-x265 \
  --disable-rav1e

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
