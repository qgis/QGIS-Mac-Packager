function build_xerces() {
  try mkdir -p $BUILD_PATH/xerces/build-$ARCH
  try cd $BUILD_PATH/xerces/build-$ARCH
  push_env

  try $CMAKE $BUILD_xerces .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  install_name_tool -id $STAGE_PATH/lib/$LINK_libxerces_c $STAGE_PATH/lib/$LINK_libxerces_c
  try install_name_tool -change $BUILD_PATH/xerces/build-$ARCH/src/$LINK_libxerces_c $STAGE_PATH/lib/$LINK_libxerces_c $STAGE_PATH/bin/CreateDOMDocument

  pop_env
}
