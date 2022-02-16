function build_libxml2() {
  try cd $BUILD_PATH/libxml2/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --without-lzma \
    --without-python \
    --with-history

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  if [ ! -e $STAGE_PATH/include/libxml ]; then
    mk_sym_link $STAGE_PATH/include ./libxml2/libxml libxml
  fi

  pop_env
}
