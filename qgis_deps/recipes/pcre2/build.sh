function build_pcre2() {
  try cd $BUILD_PATH/pcre2/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-dependency-tracking \
      --enable-pcre2-8 \
      --enable-pcre2-16 \
      --enable-pcre2-32 \
      --enable-pcre2grep-libz \
      --enable-pcre2grep-libbz2

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
