function build_python_pyqt_builder() {
  try mkdir -p $BUILD_python_pyqt_builder
  try cd $BUILD_python_pyqt_builder
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY pyqt_builder==${VERSION_python_pyqt_builder}

  pop_env
}
