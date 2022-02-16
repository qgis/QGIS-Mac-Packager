function build_wxmac() {
  try cd $BUILD_PATH/wxmac/build-$ARCH
  push_env

  try ${CONFIGURE} \
     --enable-clipboard \
     --enable-controls \
     --enable-dataviewctrl \
     --enable-display \
     --enable-dnd \
     --enable-graphics_ctx \
     --enable-std_string \
     --enable-svg \
     --enable-unicode \
     --with-expat \
     --with-libjpeg \
     --with-libpng \
     --with-libtiff \
     --with-opengl \
     --with-osx_cocoa \
     --with-zlib \
     --disable-precomp-headers \
     --disable-monolithic \
     --with-macosx-version-min=${MACOSX_DEPLOYMENT_TARGET}


  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}
