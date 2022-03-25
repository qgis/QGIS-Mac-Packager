function build_python_pysal() {
  try cd $BUILD_python_pysal
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
