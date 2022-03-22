function build_libgeotiff() {
  try mkdir -p ${DEPS_BUILD_PATH}/libgeotiff/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/libgeotiff/build-$ARCH

  push_env

  # TODO why this is only static library!??
  try $CMAKE \
  $BUILD_libgeotiff .

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env
}


#  -DPROJ_DIR=${STAGE_PATH}/share/cmake/proj4 \
 #  -DPROJ_INCLUDE_DIR=${STAGE_PATH}/include \