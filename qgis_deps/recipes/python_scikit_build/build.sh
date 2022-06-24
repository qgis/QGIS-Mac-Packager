function build_python_scikit_build() {
  mkdir -p $BUILD_python_scikit_build
  try cd $BUILD_python_scikit_build
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY scikit-build==${VERSION_python_scikit_build}

  pop_env
}
