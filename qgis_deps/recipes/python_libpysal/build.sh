function build_python_libpysal() {
  try cd ${DEPS_BUILD_PATH}/python_libpysal/build-${ARCH}
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY charset-normalizer==2.0.0
  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY soupsieve==2.3.2.post1

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
