function build_python_pillow() {
  try cd $BUILD_PATH/python_pillow/build-$ARCH
  push_env

  # unfortunately they named the file Zip.h, clashing with the lzip library
  # see https://github.com/python-pillow/Pillow/pull/4812
  try mv src/libImaging/Zip.h src/libImaging/Zip2.h
  try ${SED} "s;Zip.h;Zip2.h;g" src/libImaging/ZipDecode.c
  try ${SED} "s;Zip.h;Zip2.h;g" src/libImaging/ZipEncode.c
  try ${SED} "s;Zip.h;Zip2.h;g" src/decode.c
  try ${SED} "s;Zip.h;Zip2.h;g" src/encode.c

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}
