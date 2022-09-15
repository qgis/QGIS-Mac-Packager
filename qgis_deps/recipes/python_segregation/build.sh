function build_python_segregation() {
  try cd $BUILD_python_segregation
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
