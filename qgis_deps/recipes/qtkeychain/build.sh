function build_qtkeychain() {
  try mkdir -p ${DEPS_BUILD_PATH}/qtkeychain/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/qtkeychain/build-$ARCH
  push_env

  try ${CMAKE} \
    -DQTKEYCHAIN_STATIC=OFF \
    -DBUILD_WITH_QT6=OFF \
    -DBUILD_TEST_APPLICATION=ON \
    -DBUILD_TRANSLATIONS=OFF \
    $BUILD_qtkeychain

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env
}
