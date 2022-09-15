function build_python_sympy() {
  try cd $BUILD_python_sympy
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
