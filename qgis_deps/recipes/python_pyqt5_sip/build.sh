function build_python_pyqt5_sip() {
  mkdir -p $BUILD_python_pyqt5_sip
  try cd $BUILD_python_pyqt5_sip
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY PyQt5-sip==${VERSION_python_pyqt5_sip}

  pop_env
}
