function build_python_fiona() {
  try cd ${DEPS_BUILD_PATH}/python_fiona/build-$ARCH
  push_env

  export GDAL_CONFIG=$STAGE_PATH/bin/gdal-config
  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install
  unset GDAL_CONFIG

  pop_env
}
