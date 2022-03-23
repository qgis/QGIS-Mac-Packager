function build_python_pypubsub() {
  try cd ${DEPS_BUILD_PATH}/python_pypubsub/build-$ARCH

  push_env

  export pypubsub_DIR=$STAGE_PATH

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  unset pypubsub_DIR

  pop_env
}
