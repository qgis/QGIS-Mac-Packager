function build_python_pyqt5() {
  try cd $BUILD_PATH/python_pyqt5/build-$ARCH

  push_env

  try $PYTHON ./configure.py \
    --confirm-license \
    --stubsdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --sipdir=$STAGE_PATH/share/sip/PyQt5 \
    --bindir=$STAGE_PATH/bin \
    --sip-incdir=$STAGE_PATH/include \
    --destdir=$QGIS_SITE_PACKAGES_PATH \
    --disable=QAxContainer \
    --disable=QtX11Extras \
    --disable=QtWinExtras \
    --disable=Enginio \
    --designer-plugindir=$STAGE_PATH/share/plugins \
    --qml-plugindir=$STAGE_PATH/share/plugins \
    --verbose

  try $MAKESMP
  try $MAKE install
  try $MAKE clean

  fix_python_pyqt5_paths

  pop_env
}
