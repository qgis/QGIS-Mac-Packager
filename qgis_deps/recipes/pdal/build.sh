function build_pdal() {
  try mkdir -p $BUILD_PATH/pdal/build-$ARCH
  try cd $BUILD_PATH/pdal/build-$ARCH
  push_env

  try ${CMAKE} \
    -DWITH_LASZIP=TRUE \
    -DBUILD_PLUGIN_GREYHOUND=OFF \
    -DBUILD_PLUGIN_ICEBRIDGE=OFF \
    -DBUILD_PLUGIN_PCL=OFF \
    -DBUILD_PLUGIN_HDF=ON \
    -DBUILD_PLUGIN_PGPOINTCLOUD=OFF \
    -DBUILD_PLUGIN_PYTHON=OFF \
    -DBUILD_PLUGIN_SQLITE=OFF \
    -DWITH_TESTS=OFF \
    $BUILD_pdal
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdalcpp
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdalcpp

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_plugin_kernel_fauxplugin

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util

  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdalcpp $STAGE_PATH/lib/$LINK_libpdalcpp $STAGE_PATH/bin/pdal
  try install_name_tool -change $BUILD_PATH/pdal/build-$ARCH/lib/$LINK_libpdal_util $STAGE_PATH/lib/$LINK_libpdal_util $STAGE_PATH/bin/pdal

  pop_env
}
