function build_python_matplotlib() {
  try cd ${DEPS_BUILD_PATH}/python_matplotlib/build-$ARCH
  push_env

  CFLAGS="$CFLAGS -I$STAGE_PATH/include/freetype2"
  CPPFLAGS="$CPPFLAGS -I$STAGE_PATH/include/freetype2"

  try cp $RECIPE_python_matplotlib/setup.cfg ${DEPS_BUILD_PATH}/python_matplotlib/build-$ARCH/

  export PKG_CONFIG=$STAGE_PATH/lib/pkgconfig
  try $PYTHON setup.py install
  unset PKG_CONFIG

  pop_env
}
