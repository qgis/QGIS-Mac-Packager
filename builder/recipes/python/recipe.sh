#!/bin/bash

# version of your package (set in config.conf)
VERSION_python=${VERSION_python}

# dependencies of this recipe
DEPS_python=(hdf5)

# url of the package
URL_python=${PYTHON_BASE}

# md5 of the package
MD5_python=

# default build path
BUILD_python=$BUILD_PATH/python/v${VERSION_python}

# default recipe path
RECIPE_python=$RECIPES_PATH/python

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python() {
  try mkdir -p $BUILD_python
  cd $BUILD_python

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python() {
  # if [ ${STAGE_PATH}/lib/libpython.dylib -nt $BUILD_python/.patched ]; then
  #   DO_BUILD=0
  # fi
  :
}

# function called to build the source code
function build_python() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  pip3 install requests==2.23.0

  pip3 install --global-option=build_ext \
               --global-option="--include-dirs=$STAGE_PATH/include" \
               --global-option="--library-dirs=$STAGE_PATH/lib" \
               --global-option="--build-temp=$BUILD_PATH/proj/build-$ARCH/h5py" \
               --no-binary all \
               h5py==2.10.0



  pop_env
}

# function called after all the compile have been done
function postbuild_python() {
  # verify_lib "${STAGE_PATH}/lib/libpython.dylib"
  :
}
