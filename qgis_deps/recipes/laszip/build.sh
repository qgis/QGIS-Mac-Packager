function build_laszip() {
  try mkdir -p ${DEPS_BUILD_PATH}/laszip/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/laszip/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_laszip
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_liblaszip_api $STAGE_PATH/lib/$LINK_liblaszip_api
  try install_name_tool -id $STAGE_PATH/lib/$LINK_liblaszip $STAGE_PATH/lib/$LINK_liblaszip

  pop_env
}
