function build_hdf5() {
  try cd $BUILD_PATH/hdf5/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --enable-build-mode=release \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --enable-build-mode=production \
    --enable-cxx \
    --disable-fortran \
    --with-szlib=no
    # enable-parallel ??? MPI Support

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
