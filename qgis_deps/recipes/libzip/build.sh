function build_libzip() {
  try mkdir -p ${DEPS_BUILD_PATH}/libzip/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/libzip/build-$ARCH
  push_env

  # see issue #38: with ENABLE_GNUTLS it requires nette library
  try ${CMAKE} \
    -DENABLE_GNUTLS=FALSE \
    -DENABLE_MBEDTLS=FALSE \
    -DCMAKE_DISABLE_FIND_PACKAGE_NETTLE=TRUE \
    $BUILD_libzip

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libzip $STAGE_PATH/lib/$LINK_libzip
  try install_name_tool -change ${DEPS_BUILD_PATH}/libzip/build-$ARCH/lib/$LINK_libzip $STAGE_PATH/lib/$LINK_libzip $STAGE_PATH/bin/ziptool

  pop_env
}
