function build_python_pybind11() {
  try cd $BUILD_python_pybind11
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
