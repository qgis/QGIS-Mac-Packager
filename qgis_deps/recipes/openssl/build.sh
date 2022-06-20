function build_openssl() {
  try cd ${DEPS_BUILD_PATH}/openssl/build-$ARCH
  push_env

  # This could interfere with how we expect OpenSSL to build.
  unset OPENSSL_LOCAL_CONFIG_DIR

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  try perl ./Configure \
    --prefix=$STAGE_PATH \
    --openssldir=$STAGE_PATH \
    darwin64-${ARCH}-cc enable-ec_nistp_64_gcc_128 \
    no-ssl3 \
    no-ssl3-method \
    no-zlib \

  check_file_configuration config.status

  try $MAKESMP
  # do not build docs: https://github.com/openssl/openssl/issues/8170#issuecomment-461122307
  try $MAKESMP install_sw install_ssldirs

  pop_env
}
