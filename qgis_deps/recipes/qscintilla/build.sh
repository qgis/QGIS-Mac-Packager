function build_qscintilla() {
  try cd ${DEPS_BUILD_PATH}/qscintilla/build-$ARCH
  push_env

  cd src
  try ${QMAKE} qscintilla.pro

  try $MAKESMP
  try $MAKESMP install
  
  try install_name_tool -id $STAGE_PATH/lib/$LINK_libqscintilla2_qt5 $STAGE_PATH/lib/$LINK_libqscintilla2_qt5
  try install_name_tool -change @rpath/$LINK_libqscintilla2_qt5 $STAGE_PATH/lib/$LINK_libqscintilla2_qt5 $STAGE_PATH/lib/$LINK_libqscintilla2_qt5

  declare -a QT_LIB=()
  for QT_LIB in 'QtPrintSupport' 'QtWidgets' 'QtMacExtras' 'QtGui' 'QtCore'; do
    try install_name_tool -change @rpath/$QT_LIB.framework/Versions/5/$QT_LIB $QT_BASE/clang_64/lib/$QT_LIB.framework/Versions/5/$QT_LIB $STAGE_PATH/lib/$LINK_libqscintilla2_qt5
  done
  pop_env
}
