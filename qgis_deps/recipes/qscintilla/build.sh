function build_qscintilla() {
  try cd ${DEPS_BUILD_PATH}/qscintilla/build-$ARCH
  push_env

  cd Qt4Qt5
  try ${QMAKE} qscintilla.pro

  try $MAKESMP
  try $MAKESMP install

  pop_env
}
