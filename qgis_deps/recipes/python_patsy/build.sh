function build_python_patsy() {
  try cd $BUILD_PATH/python_patsy/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
