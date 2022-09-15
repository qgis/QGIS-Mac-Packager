function build_python_momepy() {
  try cd $BUILD_python_momepy
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
