function build_boost() {
  try cd ${DEPS_BUILD_PATH}/boost/build-$ARCH
  push_env

  try ./bootstrap.sh \
    --prefix="${STAGE_PATH}" \
    --with-toolset=clang \
    --with-icu="${STAGE_PATH}" \
    --with-python="$PYTHON" \
    --with-python-root="$PYTHON" \
    --with-python-version="$VERSION_major_python"

  try ./b2 \
    --with-python \
    install
    
  try install_name_tool -id $STAGE_PATH/lib/$LINK_boost $STAGE_PATH/lib/$LINK_boost

  pop_env
}


#     variant=release \
  #    debug-symbols=off \
  #    threading=multi \
  #    runtime-link=shared \
  #    link=shared \
  #    toolset=clang \
  #    include="${STAGE_PATH}/include" \
  #    python="$VERSION_major_python" \
  #    cxxflags="${CXXFLAGS}" \
  #    linkflags="-L$${STAGE_PATH}/lib" \
  #    --layout=system \
  #    --with-python \
  #    -j"${CORES}" \