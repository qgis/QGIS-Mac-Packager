function build_proj() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  try $CMAKE \
    -DPROJ_CMAKE_SUBDIR=share/cmake/proj4 \
    -DPROJ_DATA_SUBDIR=share/proj \
    -DPROJ_INCLUDE_SUBDIR=include \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=ON \
  $BUILD_proj .

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libproj $STAGE_PATH/lib/$LINK_libproj
  try install_name_tool -change $BUILD_PATH/proj/build-$ARCH/lib/$LINK_libproj $STAGE_PATH/lib/$LINK_libproj $STAGE_PATH/bin/proj
  try install_name_tool -delete_rpath $BUILD_PATH/proj/build-$ARCH/lib ${STAGE_PATH}/lib/$LINK_libproj

  pop_env
}