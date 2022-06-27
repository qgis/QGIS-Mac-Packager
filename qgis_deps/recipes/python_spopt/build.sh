function build_python_spopt() {
  try cd ${DEPS_BUILD_PATH}/python_spopt/build-${ARCH}
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
