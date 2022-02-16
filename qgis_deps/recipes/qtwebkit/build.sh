function build_qtwebkit() {
  try mkdir -p $BUILD_PATH/qtwebkit/build-$ARCH
  try cd $BUILD_PATH/qtwebkit/build-$ARCH
  push_env

  try ${CMAKE} \
    -DPORT=Qt \
    -DENABLE_TOOLS=FALSE \
    -DENABLE_API_TESTS=FALSE \
    -DSHOULD_INSTALL_JS_SHELL=FALSE \
    -DUSE_LIBHYPHEN=OFF \
    -DMACOS_USE_SYSTEM_ICU=OFF \
    -DMACOS_FORCE_SYSTEM_XML_LIBRARIES=OFF \
    -DQT_INSTALL_PREFIX=$QT_BASE/clang_64 \
    $BUILD_qtwebkit

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA_INSTALL

  pop_env
}
