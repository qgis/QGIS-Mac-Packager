function build_fontconfig() {
  try cd ${DEPS_BUILD_PATH}/fontconfig/build-$ARCH

  push_env

  export LIBTOOLIZE="glibtoolize"
  export GETTEXTIZE="ggettextize"
  export AUTOPOINT="gautopoint"

  try ${CONFIGURE}

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install

  unset LIBTOOLIZE
  unset GETTEXTIZE
  unset AUTOPOINT

  pop_env
}
