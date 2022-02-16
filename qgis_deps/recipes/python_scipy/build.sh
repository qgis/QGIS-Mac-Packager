function build_python_scipy() {
  try cd $BUILD_PATH/python_scipy/build-$ARCH
  push_env

  # scipy/sparse/linalg/dsolve/SuperLU/SRC/clacon2.c:175:5: error: implicit declaration of function 'ccopy_' is invalid in C99
  export CFLAGS="$CFLAGS -Wno-implicit-function-declaration"

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
