function build_python_pyproj() {
  try cd ${DEPS_BUILD_PATH}/python_pyproj/build-$ARCH
  push_env

  export PROJ_DIR=${STAGE_PATH}
  export PROJ_LIBDIR=${STAGE_PATH}
  export PROJ_INCDIR=${STAGE_PATH}

  try $PYTHON setup.py install

  pop_env
}
