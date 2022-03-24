function build_python_spaghetti() {
  try cd $BUILD_python_spaghetti
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY libspaghetti==${VERSION_python_libspaghetti}
  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY spaghetti==${VERSION_python_spaghetti}

  pop_env
}
