function build_minizip() {
  try mkdir -p ${DEPS_BUILD_PATH}/minizip/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/minizip/build-$ARCH
  push_env

  try ${CMAKE} \
    -DZLIB_INCLUDE_DIR=$STAGE_PATH/include \
    -DZLIB_LIBRARY=$STAGE_PATH/lib/$LINK_zlib \
    $BUILD_minizip

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id $STAGE_PATH/lib/$LINK_libminizip $STAGE_PATH/lib/$LINK_libminizip

  pop_env
}
