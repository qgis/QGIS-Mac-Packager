function build_geos() {
  try mkdir -p $BUILD_PATH/geos/build-$ARCH
  try cd $BUILD_PATH/geos/build-$ARCH
  push_env

  try ${CMAKE} -DGEOS_ENABLE_TESTS=OFF $BUILD_geos
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos
  try install_name_tool -id $STAGE_PATH/lib/$LINK_libgeos_c $STAGE_PATH/lib/$LINK_libgeos_c
  try install_name_tool -change $BUILD_PATH/geos/build-$ARCH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos_c

  pop_env
}
