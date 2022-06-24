function build_python_owslib() {
  try mkdir -p $BUILD_python_owslib
  cd $BUILD_python_owslib

  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY owslib==${VERSION_python_owslib}

  pop_env
}
