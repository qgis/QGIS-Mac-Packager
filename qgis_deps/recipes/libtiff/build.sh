function build_libtiff() {
  try mkdir -p $BUILD_PATH/libtiff/build-$ARCH
  try cd $BUILD_PATH/libtiff/build-$ARCH

  push_env

  try $CMAKE \
   -DWEBP_SUPPORT=BOOL:ON \
   -DLZMA_SUPPORT=BOOL:ON \
   -DZSTD_SUPPORT=BOOL:ON \
   -DLERC_SUPPORT=BOOL:ON \
   -DJPEG_SUPPORT=BOOL:ON \
   -DZIP_SUPPORT=BOOL:ON \
  $BUILD_libtiff .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiff

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiffxx
  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx $STAGE_PATH/lib/$LINK_libtiffxx

  try install_name_tool -change $BUILD_PATH/libtiff/build-$ARCH/libtiff/$LINK_libtiff $STAGE_PATH/lib/$LINK_libtiff $STAGE_PATH/bin/tiffsplit

  pop_env
}
