function build_python_pubsub() {
  try cd ${DEPS_BUILD_PATH}/python_pubsub/build-$ARCH

  push_env

  export pubsub_DIR=$STAGE_PATH

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  unset pubsub_DIR

  pop_env
}
