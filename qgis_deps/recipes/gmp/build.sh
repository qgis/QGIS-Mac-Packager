function build_gmp() {
  try cd ${DEPS_BUILD_PATH}/gmp/build-$ARCH
  push_env

  export CFLAGS="$CFLAGS -fno-stack-check"

  try ${CONFIGURE} --enable-cxx --with-pic

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
