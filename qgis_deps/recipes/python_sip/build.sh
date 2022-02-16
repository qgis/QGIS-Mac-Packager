function build_python_sip() {
  try cd $BUILD_PATH/python_sip/build-$ARCH

  push_env

  try $PYTHON ./configure.py \
    --sipdir=$STAGE_PATH/share/sip \
    --bindir=$STAGE_PATH/bin \
    --deployment-target=$MACOSX_DEPLOYMENT_TARGET \
    --destdir=$QGIS_SITE_PACKAGES_PATH \
    --incdir=$STAGE_PATH/include \
    --sip-module=PyQt5.sip

  try $MAKESMP
  try $MAKE install
  try $MAKE clean


  # default directory for sip files
  mkdir -p ${STAGE_PATH}/share/sip

  pop_env
}
