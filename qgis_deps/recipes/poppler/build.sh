function build_poppler() {
  try mkdir -p ${DEPS_BUILD_PATH}/poppler/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/poppler/build-$ARCH
  push_env

  # ENABLE_UNSTABLE_API_ABI_HEADERS=ON is equivalent to enable-xpdf-headers

  try ${CMAKE} \
    -DBUILD_GTK_TESTS=OFF \
    -DBUILD_CPP_TESTS=OFF \
    -DENABLE_BOOST=ON \
    -DBoost_DIR=${STAGE_PATH}/boost \
    -DBoost_INCLUDE_DIR=${STAGE_PATH}/include \
    -DWITH_Cairo=OFF \
    -DWITH_NSS3=OFF \
    -DENABLE_CMS=lcms2 \
    -DENABLE_GLIB=OFF \
    -DENABLE_QT5=ON \
    -DENABLE_QT6=OFF \
    -DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
    -DENABLE_GOBJECT_INTROSPECTION=ON \
    $BUILD_poppler

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler
  install_name_tool -id $STAGE_PATH/lib/$LINK_poppler_cpp $STAGE_PATH/lib/$LINK_poppler_cpp
  install_name_tool -id $STAGE_PATH/lib/$LINK_poppler_qt5 $STAGE_PATH/lib/$LINK_poppler_qt5

  install_name_tool -change ${DEPS_BUILD_PATH}/poppler/build-$ARCH/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler_cpp
  install_name_tool -change ${DEPS_BUILD_PATH}/poppler/build-$ARCH/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler $STAGE_PATH/lib/$LINK_poppler_qt5

  pop_env
}
