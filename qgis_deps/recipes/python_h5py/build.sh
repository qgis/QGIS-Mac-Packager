function build_python_h5py() {
  try cd $BUILD_python_h5py
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY h5py==${VERSION_python_h5py}

  pop_env
}
