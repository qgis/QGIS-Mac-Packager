function build_png() {
  try mkdir -p ${DEPS_BUILD_PATH}/png/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/png/build-$ARCH
  push_env

  try ${CMAKE} \
    $BUILD_png

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install
  
  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpng $STAGE_PATH/lib/$LINK_libpng
  try install_name_tool -change ${DEPS_BUILD_PATH}/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpng

  pop_env
}
