function build_qwt() {
  try cd $BUILD_PATH/qwt/build-$ARCH
  push_env

  try ${QMAKE}

  try $MAKESMP
  try $MAKESMP_INSTALL

  install_name_tool -id "@rpath/qwt.framework/qwt" ${STAGE_PATH}/lib/qwt.framework/qwt

  pop_env
}
