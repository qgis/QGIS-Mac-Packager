function build_uriparser() {
  try mkdir -p $BUILD_PATH/uriparser/build-$ARCH
  try cd $BUILD_PATH/uriparser/build-$ARCH
  push_env

  try ${CMAKE} \
    -DURIPARSER_BUILD_DOCS=OFF \
    -DURIPARSER_BUILD_TESTS=OFF \
    $BUILD_uriparser

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  install_name_tool -id $STAGE_PATH/lib/$LINK_liburiparser $STAGE_PATH/lib/$LINK_liburiparser

  pop_env
}
