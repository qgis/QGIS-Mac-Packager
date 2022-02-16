function build_libzip() {
  try mkdir -p $BUILD_PATH/libzip/build-$ARCH
  try cd $BUILD_PATH/libzip/build-$ARCH
  push_env

  # see issue #38: with ENABLE_GNUTLS it requires nette library
  try ${CMAKE} \
    -DENABLE_GNUTLS=FALSE \
    -DENABLE_MBEDTLS=FALSE \
    -DCMAKE_DISABLE_FIND_PACKAGE_NETTLE=TRUE \
    $BUILD_libzip

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libzip $STAGE_PATH/lib/$LINK_libzip
  try install_name_tool -change $BUILD_PATH/libzip/build-$ARCH/lib/$LINK_libzip $STAGE_PATH/lib/$LINK_libzip $STAGE_PATH/bin/ziptool

  pop_env
}
