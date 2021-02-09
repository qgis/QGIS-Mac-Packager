#!/bin/bash

DESC_python="Interpreted, interactive, object-oriented programming language"

# version of your package (set in config.conf)
VERSION_minor_python=7
VERSION_python=${VERSION_major_python}.${VERSION_minor_python}
LINK_python=libpython3.7m.dylib

# dependencies of this recipe
DEPS_python=( openssl xz libffi zlib libzip sqlite expat unixodbc bz2 gettext libarchive libiconv libcurl )

# url of the package
URL_python=https://www.python.org/ftp/python/${VERSION_python}/Python-${VERSION_python}.tar.xz

# md5 of the package
MD5_python=60fe018fffc7f33818e6c340d29e2db9

# default build path
BUILD_python=$BUILD_PATH/python/$(get_directory $URL_python)

# default recipe path
RECIPE_python=$RECIPES_PATH/python

# requirements
REQUIREMENTS_python=(
  setuptools==https://files.pythonhosted.org/packages/df/ed/bea598a87a8f7e21ac5bbf464102077c7102557c07db9ff4e207bd9f7806/setuptools-46.0.0.zip==74de3ab356d1246d251977e16a44ef1e
  pip==https://files.pythonhosted.org/packages/8e/76/66066b7bc71817238924c7e4b448abdb17eb0c92d645769c223f9ace478f/pip-20.0.2.tar.gz==7d42ba49b809604f0df3d55df1c3fd86
  wheel==https://files.pythonhosted.org/packages/75/28/521c6dc7fef23a68368efefdcd682f5b3d1d58c2b90b06dc1d0b805b51ae/wheel-0.34.2.tar.gz==ce2a27f99c130a927237b5da1ff5ceaf
)

install_default_packages () {
  for i in ${REQUIREMENTS_python[*]}
  do
    arr=(${i//==/ })
    NAME=${arr[0]}
    URL=${arr[1]}
    MD5=${arr[2]}
    download_file $NAME $URL $MD5

    info "Installing $NAME"

    cd $BUILD_PATH/$NAME/$(get_directory $URL)
    push_env

    # when building extensions in setup.py it
    # dlopen some libraries (e.g. _ssl -> libcrypto.dylib)
    export DYLD_LIBRARY_PATH=$STAGE_PATH/lib

    if [ "X$NAME" == "Xsetuptools" ]; then
        try $PYTHON bootstrap.py
    fi

    echo `pwd`

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

  try ${CONFIGURE} \
      --enable-ipv6 \
      --datarootdir=$STAGE_PATH/share \
      --datadir=$STAGE_PATH/share \
      --without-gcc \
      --with-openssl=$STAGE_PATH \
      --enable-optimizations \
      --enable-shared \
      --with-system-expat \
      --with-system-ffi \
      --with-ensurepip=no \
      --with-ssl-default-suites=openssl \
      --enable-loadable-sqlite-extensions \
      --with-system-ffi

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install PYTHONAPPSDIR=${STAGE_PATH}

  pop_env
}

# function called to build the source code
function build_python() {
   # install_python
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

# function to append information to config file
function add_config_info_python() {
  append_to_config_file "# python-${VERSION_python}: ${DESC_python}"
  append_to_config_file "export VERSION_python=${VERSION_python}"
  append_to_config_file "export LINK_python=${LINK_python}"
}