function build_python_pythran() {
  try cd ${DEPS_BUILD_PATH}/python_pythran/build-${ARCH}
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
