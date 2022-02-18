function build_bz2() {
  try cd ${DEPS_BUILD_PATH}/bz2/build-$ARCH
  push_env

  try $MAKESMP PREFIX=$STAGE_PATH
  try $MAKE install PREFIX=$STAGE_PATH

  try ${SED} "s;-shared -Wl,-soname -Wl,libbz2.so.$VERSION_bz2_major -o libbz2.so.$VERSION_bz2;-dynamiclib -install_name libbz2.$VERSION_bz2_major.dylib -current_version $VERSION_bz2 -compatibility_version $VERSION_bz2_major -o libbz2.$VERSION_bz2.dylib;g" Makefile-libbz2_so
  try ${SED} "s;libbz2.so.$VERSION_bz2;libbz2.$VERSION_bz2.dylib;g" Makefile-libbz2_so
  try ${SED} "s;libbz2.so.$VERSION_bz2_major;libbz2.$VERSION_bz2_major.dylib;g" Makefile-libbz2_so

  try $MAKESMP PREFIX=$STAGE_PATH -f Makefile-libbz2_so
  ln -s libbz2.$VERSION_bz2_major.dylib libbz2.dylib
  try cp -av libbz2.*dylib $STAGE_PATH/lib/
  try install_name_tool -id $STAGE_PATH/lib/libbz2.$VERSION_bz2_major.dylib $STAGE_PATH/lib/libbz2.$VERSION_bz2_major.dylib

  pop_env
}
