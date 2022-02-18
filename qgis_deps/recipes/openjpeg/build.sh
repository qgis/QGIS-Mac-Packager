function build_openjpeg() {
  try cd ${DEPS_BUILD_PATH}/openjpeg/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBUILD_DOC=OFF \
    $BUILD_openjpeg
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id $STAGE_PATH/lib/$LINK_openjpeg $STAGE_PATH/lib/$LINK_openjpeg

  pop_env
}
