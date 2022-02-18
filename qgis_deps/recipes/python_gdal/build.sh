function build_python_gdal() {
  try cd ${DEPS_BUILD_PATH}/python_gdal/build-$ARCH
  push_env

  cd swig/python
  try ${SED} "s;gdal_config=../../apps/gdal-config;gdal_config=$STAGE_PATH/bin/gdal-config;g" setup.cfg
  try $PYTHON setup.py build
  try $PYTHON setup.py install

  pop_env
}
