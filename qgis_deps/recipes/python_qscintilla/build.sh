function build_python_qscintilla() {
  try cd ${DEPS_BUILD_PATH}/python_qscintilla/build-$ARCH
  push_env

  # build python
  cd Python
  mkdir -p ${STAGE_PATH}/share/sip/PyQt5/Qsci

  # QMAKEFEATURES=$STAGE_PATH/data/mkspecs/features;\
  try $PYTHON ./configure.py \
    -o ${STAGE_PATH}/lib \
    -n ${STAGE_PATH}/include \
    --apidir=${STAGE_PATH}/qsci \
    --stubsdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --destdir=$QGIS_SITE_PACKAGES_PATH/PyQt5 \
    --qsci-featuresdir=$STAGE_PATH/data/mkspecs/features/ \
    --qsci-sipdir=${STAGE_PATH}/share/sip/PyQt5 \
    --qsci-incdir=${STAGE_PATH}/include \
    --qsci-libdir=${STAGE_PATH}/lib \
    --pyqt=PyQt5 \
    --pyqt-sipdir=${STAGE_PATH}/share/sip/PyQt5 \
    --sip-incdir=${STAGE_PATH}/include \
    --spec=${QSPEC} \
    --verbose

  try $MAKESMP
  try $MAKESMP install
  try $MAKE clean

  install_name_tool -add_rpath "${STAGE_PATH}/lib" $QGIS_SITE_PACKAGES_PATH/PyQt5/Qsci.so

  pop_env
}
