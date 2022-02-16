function build_qca() {
  try mkdir -p $BUILD_PATH/qca/build-$ARCH
  try cd $BUILD_PATH/qca/build-$ARCH
  push_env

  try ${CMAKE} \
    -DQCA_PLUGINS_INSTALL_DIR=$STAGE_PATH/qt5/plugins \
    -DQT4_BUILD=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_botan_PLUGIN=NO \
    -DWITH_gcrypt_PLUGIN=NO \
    -DWITH_gnupg_PLUGIN=NO \
    -DWITH_nss_PLUGIN=NO \
    -DWITH_pkcs11_PLUGIN=NO \
  $BUILD_qca

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env
}
