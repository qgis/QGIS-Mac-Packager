function build_python_libpysal() {
  try cd $BUILD_python_libpysal
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY libpysal==${VERSION_python_libpysal}
  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY pysal==${VERSION_python_pysal}

  pop_env
}
