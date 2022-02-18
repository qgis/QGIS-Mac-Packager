function build_libomp() {
  try mkdir -p ${DEPS_BUILD_PATH}/libomp/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/libomp/build-$ARCH

  push_env

  try $CMAKE \
    -DLIBOMP_INSTALL_ALIASES=OFF \
    $BUILD_libomp .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id ${STAGE_PATH}/lib/${LINK_libomp} ${STAGE_PATH}/lib/${LINK_libomp}

  pop_env
}
