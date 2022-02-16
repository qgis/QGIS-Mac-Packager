function build_python_pandas() {
  try cd $BUILD_PATH/python_pandas/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
