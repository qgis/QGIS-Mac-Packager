function build_libaom() {
  try mkdir -p $BUILD_PATH/libaom/build-$ARCH
  try cd $BUILD_PATH/libaom/build-$ARCH

  push_env

  try $CMAKE -DAOM_TARGET_CPU=generic -DCONFIG_SHARED=ON $BUILD_libaom
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id ${STAGE_PATH}/lib/${LINK_libaom} ${STAGE_PATH}/lib/${LINK_libaom}

  pop_env
}
