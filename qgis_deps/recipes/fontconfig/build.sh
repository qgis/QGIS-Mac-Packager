function build_fontconfig() {
  try cd ${DEPS_BUILD_PATH}/fontconfig/build-$ARCH

  push_env

  export LIBTOOLIZE="glibtoolize"
  export GETTEXTIZE="ggettextize"
  export AUTOPOINT="gautopoint"
  export PKG_CONFIG=/usr/local/opt/pkg-config/bin/pkg-config

  try ${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-docs \
    --disable-cache-build

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install

  unset LIBTOOLIZE
  unset GETTEXTIZE
  unset AUTOPOINT

  pop_env
}
