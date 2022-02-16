function build_minizip() {
  try mkdir -p $BUILD_PATH/minizip/build-$ARCH
  try cd $BUILD_PATH/minizip/build-$ARCH
  push_env

  try ${CMAKE} \
    -DZLIB_INCLUDE_DIR=$STAGE_PATH/include \
    -DZLIB_LIBRARY=$STAGE_PATH/lib/$LINK_zlib \
    $BUILD_minizip

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  install_name_tool -id $STAGE_PATH/lib/$LINK_libminizip $STAGE_PATH/lib/$LINK_libminizip

  pop_env
}
