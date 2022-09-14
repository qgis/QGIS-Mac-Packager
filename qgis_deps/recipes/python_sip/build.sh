function build_python_sip() {
  try mkdir -p $BUILD_python_sip
  try cd $BUILD_python_sip
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY sip==${VERSION_python_sip}

  pop_env
}
