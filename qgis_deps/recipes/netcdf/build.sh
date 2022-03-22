function build_netcdf() {
  try mkdir -p ${DEPS_BUILD_PATH}/netcdf/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/netcdf/build-$ARCH
  push_env

  try ${CMAKE} -DENABLE_EXAMPLES=OFF $BUILD_netcdf
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_netcdf $STAGE_PATH/lib/$LINK_netcdf

  pop_env
}
