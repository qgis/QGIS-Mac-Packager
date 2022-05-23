function build_libcurl() {
  try cd ${DEPS_BUILD_PATH}/libcurl/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=TRUE \
    -DBUILD_CURL_EXE=OFF \
    -DCURL_USE_LIBSSH2=OFF \
    -DCURL_USE_LIBSSH=OFF \
    -DCURL_ZSTD=ON \
    -DCURL_BROTLI=OFF \
    -DCURL_DISABLE_LDAP=ON \
    -DCURL_USE_OPENLDAP=OFF \
    -DUSE_QUICHE=OFF \
    -DUSE_NGTCP2=OFF \
    -DUSE_NGHTTP2=OFF \
    -DCURL_ZLIB=ON \
    -DCURL_USE_OPENSSL=ON \
    -DAPPLE=TRUE \
    $BUILD_libcurl

  try $NINJA
  try $NINJA install
  
  install_name_tool -id $STAGE_PATH/lib/$LINK_libcurl $STAGE_PATH/lib/$LINK_libcurl

  install_name_tool -change ${DEPS_BUILD_PATH}/libcurl/build-$ARCH/$LINK_libcurl $STAGE_PATH/lib/$LINK_libcurl $STAGE_PATH/lib/$LINK_libcurl

  pop_env
}
