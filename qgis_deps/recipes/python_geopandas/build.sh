function build_python_geopandas() {
  try cd ${DEPS_BUILD_PATH}/python_geopandas/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
