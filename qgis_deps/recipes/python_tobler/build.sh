function build_python_tobler() {
  try cd $BUILD_python_tobler
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}