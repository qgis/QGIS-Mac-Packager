function build_libcurl() {
  try cd $BUILD_PATH/libcurl/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --with-ssl=${STAGE_PATH} \
    --without-ca-bundle \
    --without-ca-path \
    --with-ca-fallback \
    --with-secure-transport \
    --with-default-ssl-backend=openssl \
    --without-libpsl \
    --without-gssapi \
    --without-libmetalink \
    --without-nghttp2 \
    --without-brotli \
    --without-librtmp \
    --with-libssh2 \
    --without-libidn2 \

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
