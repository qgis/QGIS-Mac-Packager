function build_protobuf() {
  try cd $BUILD_PATH/protobuf/build-$ARCH
  push_env

  export CXXFLAGS="$CXXFLAGS -DNDEBUG"

  try ./autogen.sh
  patch_configure_file configure
  try ${CONFIGURE} \
    --enable-static \
    --disable-debug \
    --disable-dependency-tracking \
    --with-zlib

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
