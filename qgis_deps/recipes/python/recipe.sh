#!/bin/bash

# version of your package (set in config.conf)
VERSION_python=${VERSION_major_python}.7

# dependencies of this recipe
DEPS_python=( openssl xz libffi )

# url of the package
URL_python=https://www.python.org/ftp/python/${VERSION_python}/Python-${VERSION_python}.tar.xz

# md5 of the package
MD5_python=172c650156f7bea68ce31b2fd01fa766

# default build path
BUILD_python=$BUILD_PATH/python/$(get_directory $URL_python)

# default recipe path
RECIPE_python=$RECIPES_PATH/python

patch_python_linker_links () {
  targets=(
    bin/python${VERSION_major_python}
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
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
  if [ ${STAGE_PATH}/bin/python3 -nt BUILD_python/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python() {
  try rsync -a $BUILD_python/ $BUILD_PATH/python/build-$ARCH/
  try cd $BUILD_PATH/python/build-$ARCH

  push_env

  unset PYTHONHOME
  unset PYTHONPATH
  # export CFLAGS="-isysroot $STAGE_PATH "${CFLAGS}
  # export LDFLAGS="-isysroot $STAGE_PATH "${LDFLAGS}
  # export CPPFLAGS="-isysroot $STAGE_PATH "${CPPFLAGS}

  try ${CONFIGURE} \
      --enable-ipv6 \
      --datarootdir=$STAGE_PATH/share \
      --datadir=$STAGE_PATH/share \
      --without-gcc \
      --with-openssl=$STAGE_PATH \
      --enable-optimizations \
      --enable-shared \
      --with-ssl-default-suites=openssl \
      --enable-loadable-sqlite-extensions \
      --disable-profiling

#       --enable-loadable-sqlite-extensions \
#      --enable-framework=${STAGE_PATH}/Frameworks \
            # --without-ensurepip \
#       --with-dtrace \

  check_file_configuration config.status

  # during build time it load extensions to check. need to
  # add rpath to the libs, but we need to do it after build
  # so we do not have like this
  # *** WARNING: renaming "_ssl" since importing it failed:
  # dlopen(build/lib.macosx-10.13.0-x86_64-3.7/_ssl.cpython-37m-darwin.so, 2): Symbol not found: _BIO_up_ref

  # this sets cross_compiling flag in setup.py
  export _PYTHON_HOST_PLATFORM=darwin

  # TODO how to skip running tests?
  try $MAKESMP
  try $MAKE install PYTHONAPPSDIR=${STAGE_PATH}
  # try $MAKE frameworkinstallextras PYTHONAPPSDIR=${STAGE_PATH}/share

  exit 1
  patch_python_linker_links

  try $STAGE_PATH/bin/pip3 install --upgrade pip
  try $STAGE_PATH/bin/pip3 install --upgrade setuptools
  try $STAGE_PATH/bin/pip3 install --upgrade wheel

  pop_env
}

# function called after all the compile have been done
function postbuild_python() {
    verify_bin python3
}
