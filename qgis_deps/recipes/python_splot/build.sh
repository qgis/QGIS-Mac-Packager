function build_python_splot() {
  try cd $BUILD_python_splot
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
