function build_qscintilla() {
  try cd $BUILD_PATH/qscintilla/build-$ARCH
  push_env

  cd Qt4Qt5
  try ${QMAKE} qscintilla.pro

  try $MAKESMP
  try $MAKESMP_INSTALL

  pop_env
}
