function build_geos() {
  try mkdir -p ${DEPS_BUILD_PATH}/geos/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/geos/build-$ARCH
  push_env

  try ${CMAKE} -DGEOS_ENABLE_TESTS=OFF $BUILD_geos
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos
  try install_name_tool -id $STAGE_PATH/lib/$LINK_libgeos_c $STAGE_PATH/lib/$LINK_libgeos_c
  try install_name_tool -change ${DEPS_BUILD_PATH}/geos/build-$ARCH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos_c

  pop_env
}
