#!/bin/bash

DESC_python="Interpreted, interactive, object-oriented programming language"

# version of your package (set in config.conf)
VERSION_minor_python=3
VERSION_python=${VERSION_major_python}.${VERSION_minor_python}
LINK_python=libpython${VERSION_major_python}.dylib

# dependencies of this recipe
DEPS_python=(openssl xz libffi zlib libzip sqlite expat unixodbc bz2 gettext libcurl)

# url of the package
URL_python=https://www.python.org/ftp/python/${VERSION_python}/Python-${VERSION_python}.tar.xz

# md5 of the package
MD5_python=c8d52fc4fb8ad9932a11d86d142ee73a

# default build path
BUILD_python=$BUILD_PATH/python/$(get_directory $URL_python)

# default recipe path
RECIPE_python=$RECIPES_PATH/python

# requirements
REQUIREMENTS_python=(
  setuptools==https://files.pythonhosted.org/packages/cb/46/22ec35f286a77e6b94adf81b4f0d59f402ed981d4251df0ba7b992299146/setuptools-67.6.1.tar.gz==a661b7cdf4cf1e914f866506c1022dee
  pip==https://files.pythonhosted.org/packages/da/bf/1bdbe62f5fbde085351693e3a8e387a59f8220932b911b1719fe65efa2d7/pip-23.1.tar.gz==b730fe00a3d43fa86e67472ad9d1de4d
  wheel==https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz==ec5004c46d1905da98bb5bc1a10ddd21
)

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

    cd $BUILD_PATH/$NAME/$(get_directory $URL)
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

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python() {
  cd $BUILD_python

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_python() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_python -nt BUILD_python/.patched ]; then
    DO_BUILD=0
  fi
}

function install_python() {
  try rsync -a $BUILD_python/ $BUILD_PATH/python/build-$ARCH/
  try cd $BUILD_PATH/python/build-$ARCH

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

# function called to build the source code
function build_python() {
  download_default_packages
  install_python
  install_default_packages
}

# function called after all the compile have been done
function postbuild_python() {
  verify_binary bin/python3
  verify_binary lib/$LINK_python

  if ! python_package_installed bz2; then
    error "Missing python bz2, probably libbz2 was not picked by compilation of python"
  fi
}

function postbuild_wheel() {
  :
}

# function to append information to config file
function add_config_info_python() {
  append_to_config_file "# python-${VERSION_python}: ${DESC_python}"
  append_to_config_file "export VERSION_python=${VERSION_python}"
  append_to_config_file "export LINK_python=${LINK_python}"
}
