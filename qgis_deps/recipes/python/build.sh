download_default_packages() {
  for i in ${REQUIREMENTS_python[*]}; do
    arr=(${i//==/ })
    NAME=${arr[0]}
    URL=${arr[1]}
    MD5=${arr[2]}
    info "Downloading $NAME"
    download_file $NAME $URL $MD5
  done
}

install_default_packages() {
  for i in ${REQUIREMENTS_python[*]}; do
    arr=(${i//==/ })
    NAME=${arr[0]}
    URL=${arr[1]}
    MD5=${arr[2]}

    info "Installing $NAME"

    cd ${DEPS_BUILD_PATH}/$NAME/$(get_directory $URL)
    push_env

    # when building extensions in setup.py it
    # dlopen some libraries (e.g. _ssl -> libcrypto.dylib, _ffi_call -> _ffi_call)
    export DYLD_LIBRARY_PATH=$STAGE_PATH/lib

    try $PYTHON \
      -s setup.py \
      --no-user-cfg install \
      --force \
      --verbose \
      --install-scripts=$STAGE_PATH/bin \
      --install-lib=$QGIS_SITE_PACKAGES_PATH \
      --single-version-externally-managed \
      --record=installed.txt

    pop_env

  done
}

function install_python() {
  try cd ${DEPS_BUILD_PATH}/python/build-$ARCH

  push_env

  unset PYTHONHOME
  unset PYTHONPATH

  # this sets cross_compiling flag in setup.py
  # so it does not pick /usr/local libs
  export _PYTHON_HOST_PLATFORM=darwin

  # when building extensions in setup.py it
  # dlopen some libraries (e.g. _ssl -> libcrypto.dylib)
  export DYLD_LIBRARY_PATH=$STAGE_PATH/lib

  # add unixodbc
  export CFLAGS="$CFLAGS -I$STAGE_PATH/unixodbc/include"
  export LDFLAGS="$LDFLAGS -L$STAGE_PATH/unixodbc/lib"
  export CXXFLAGS="${CFLAGS}"
  # pkg-config removes -I flags for paths in CPATH, which confuses python.
  export PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1

  #      --enable-optimizations \
  try ${CONFIGURE} \
    --enable-ipv6 \
    --datarootdir=$STAGE_PATH/share \
    --datadir=$STAGE_PATH/share \
    --without-gcc \
    --with-openssl=$STAGE_PATH \
    --enable-shared \
    --with-system-expat \
    --with-system-ffi \
    --with-computed-gotos \
    --with-ensurepip=no \
    --with-ssl-default-suites=openssl \
    --enable-loadable-sqlite-extensions

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install PYTHONAPPSDIR=${STAGE_PATH}

  pop_env
}

function build_python() {
  download_default_packages
  install_python
  install_default_packages
}
