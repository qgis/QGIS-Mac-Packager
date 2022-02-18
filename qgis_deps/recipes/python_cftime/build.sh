function build_python_cftime() {
  try cd ${DEPS_BUILD_PATH}/python_cftime/build-$ARCH

  push_env

  export HDF5_DIR=$STAGE_PATH
  export NETCDF4_DIR=$STAGE_PATH
  export CURL_DIR=$STAGE_PATH

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  unset HDF5_DIR
  unset NETCDF4_DIR
  unset CURL_DIR

  pop_env
}
