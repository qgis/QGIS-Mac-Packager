function build_python_pyqt5() {
  try mkdir -p $BUILD_python_pyqt5
  try cd $BUILD_python_pyqt5
  push_env

  try ${STAGE_PATH}/bin/sip-install --verbose --confirm-license

  fix_python_pyqt5_paths

  pop_env
}
