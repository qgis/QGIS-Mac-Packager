function build_lerc() {
  try mkdir -p $BUILD_PATH/lerc/build-$ARCH
  try cd $BUILD_PATH/lerc/build-$ARCH

  push_env

  try $CMAKE $BUILD_lerc .

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_liblerc $STAGE_PATH/lib/$LINK_liblerc

  pop_env
}
