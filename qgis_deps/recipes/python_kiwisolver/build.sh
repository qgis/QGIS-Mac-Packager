function build_python_kiwisolver() {
  try cd ${DEPS_BUILD_PATH}/python_kiwisolver/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
