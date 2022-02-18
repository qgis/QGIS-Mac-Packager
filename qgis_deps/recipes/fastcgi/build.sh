function build_fastcgi() {
  try cd ${DEPS_BUILD_PATH}/fastcgi/build-$ARCH
  push_env

  try ./autogen.sh
  patch_configure_file configure
  try ${CONFIGURE} --disable-debug --disable-dependency-tracking

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
