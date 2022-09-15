function build_python_spaghetti() {
  try mkdir -p $BUILD_python_spaghetti
  try cd $BUILD_python_spaghetti
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
