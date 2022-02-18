function build_gcc() {
 try cd ${DEPS_BUILD_PATH}/gcc/build-$ARCH
 push_env

 unset LD

 try ${CONFIGURE} \
   --enable-languages=fortran,c,c++,objc,obj-c++ \
   --disable-multilib \
   --disable-nls \
   --with-system-zlib \
   --enable-checking=release \
   --program-suffix=-${VERSION_gcc_major} \
   --with-native-system-header-dir=/usr/include \
   --with-sysroot=`xcrun --show-sdk-path` \
   --with-gmp=$STAGE_PATH \
   --with-mpfr=$STAGE_PATH \
   --with-mpc=$STAGE_PATH

  check_file_configuration config.status

  try $MAKESMP "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
  try $MAKESMP install

  cd $STAGE_PATH/bin
  ln -s gfortran-$VERSION_gcc_major gfortran
  ln -s gcc-$VERSION_gcc_major gcc
  ln -s gcc-ar-$VERSION_gcc_major gcc-ar
  ln -s gcc-nm-$VERSION_gcc_major gcc-nm
  ln -s gcc-ranlib-$VERSION_gcc_major gcc-ranlib

  pop_env
}
