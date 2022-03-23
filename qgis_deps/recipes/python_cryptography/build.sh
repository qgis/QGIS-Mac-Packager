function build_python_cryptography() {
  try cd ${DEPS_BUILD_PATH}/python_cryptography/build-$ARCH

  push_env

  export cryptography_DIR=$STAGE_PATH

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY cryptography==${VERSION_python_cryptography}

  unset cryptography_DIR

  pop_env
}
