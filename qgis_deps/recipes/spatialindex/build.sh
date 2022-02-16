function build_spatialindex() {
  try mkdir -p $BUILD_PATH/spatialindex/build-$ARCH
  try cd $BUILD_PATH/spatialindex/build-$ARCH

  push_env

  try $CMAKE $BUILD_spatialindex .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id ${STAGE_PATH}/lib/$LINK_spatialindex ${STAGE_PATH}/lib/$LINK_spatialindex
  try install_name_tool -delete_rpath $BUILD_PATH/spatialindex/build-$ARCH/bin ${STAGE_PATH}/lib/$LINK_spatialindex_c
  try install_name_tool -change @rpath/$LINK_spatialindex ${STAGE_PATH}/lib/$LINK_spatialindex ${STAGE_PATH}/lib/$LINK_spatialindex_c

  pop_env
}
