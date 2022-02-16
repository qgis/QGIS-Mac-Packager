function build_boost() {
  try cd $BUILD_PATH/boost/build-$ARCH
  push_env

  try ./bootstrap.sh \
    --prefix="${STAGE_PATH}" \
    --with-toolset=clang \
    --with-icu="${STAGE_PATH}" \
    --with-python="$PYTHON" \
    --with-python-root="$PYTHON" \
    --with-python-version="$VERSION_major_python"

  try ./b2 -q \
    variant=release \
    address-model="64" \
    architecture="arm" \
    binary-format="mach-o" \
    debug-symbols=off \
    threading=multi \
    runtime-link=shared \
    link=static,shared \
    toolset=clang \
    include="${STAGE_PATH}/include" \
    python="$VERSION_major_python" \
    cxxflags="${CXXFLAGS}" \
    linkflags="-L$${STAGE_PATH}/lib" \
    --layout=system \
    --with-python \
    -j"${CORES}" \
    install

  pop_env
}
