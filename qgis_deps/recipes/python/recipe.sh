#!/bin/bash

DESC_python="Interpreted, interactive, object-oriented programming language"

# version of your package (set in config.conf)
VERSION_minor_python=5
VERSION_python=${VERSION_major_python}.${VERSION_minor_python}
LINK_python=libpython${VERSION_major_python}.dylib

# dependencies of this recipe
DEPS_python=(openssl xz libffi zlib libzip sqlite expat unixodbc bz2 gettext libcurl)

# url of the package
URL_python=https://www.python.org/ftp/python/${VERSION_python}/Python-${VERSION_python}.tar.xz

# md5 of the package
MD5_python=71f7ada6bec9cdbf4538adc326120cfd

# default build path
BUILD_python=$BUILD_PATH/python/$(get_directory $URL_python)

# default recipe path
RECIPE_python=$RECIPES_PATH/python

# requirements
REQUIREMENTS_python=(
  setuptools==https://files.pythonhosted.org/packages/9a/74/de4d8c69466b6413b1616048b39f8b73d65f98c15f6202b68ccfc9550f1f/setuptools-58.0.4.tar.gz==17245af34e1a7d54976bca8c1bf092b7
  pip==https://files.pythonhosted.org/packages/52/e1/06c018197d8151383f66ebf6979d951995cf495629fc54149491f5d157d0/pip-21.2.4.tar.gz==efbdb4201a5e6383fb4d12e26f78f355
  wheel==https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz==79f55b898e6f274f5586bbde39f6fe8e
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
