function build_python_numpy() {
  try cd $BUILD_PATH/python_numpy/build-$ARCH
  push_env

  export OPENBLAS=$STAGE_PATH/lib
  export BLAS=None
  export LAPACK=None
  export ATLAS=None
  export ACCELERATE=None

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  unset OPENBLAS
  unset BLAS
  unset LAPACK
  unset ATLAS
  unset ACCELERATE

  pop_env
}
