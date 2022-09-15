function build_python_pygeos() {
  try cd $BUILD_python_pygeos
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
