function build_proj_data() {
  try mkdir -p $BUILD_PATH/proj_data/build-$ARCH
  try cd $BUILD_PATH/proj_data/build-$ARCH

  push_env

  try $CMAKE $BUILD_proj_data .

  check_file_configuration CMakeCache.txt

  try $NINJA dist

  mkdir -p install
  cd install
  try tar -zxf ../proj-data-${VERSION_proj_data_major}.tar.gz
  try cp -R * $STAGE_PATH/share/proj/

  pop_env
}
