#!/bin/bash

# version of your package (set in config.conf)
VERSION_python_packages=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages=(hdf5)

# url of the package
URL_python_packages=

# md5 of the package
MD5_python_packages=

# default build path
BUILD_python_packages=$BUILD_PATH/python_packages/v${VERSION_python_packages}

# default recipe path
RECIPE_python_packages=$RECIPES_PATH/python_packages

# requirements
REQUIREMENTS_python_packages=(
  numpy==1.18.2
  h5py==2.10.0
  requests==2.23.0
  PyQt5==${VERSION_qt}
)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_packages() {
  try mkdir -p $BUILD_python_packages
  cd $BUILD_python_packages

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_packages() {
  for i in ${REQUIREMENTS_python_packages[*]}
  do
    arr=(${i//==/ })
    if ! python_package_installed ${arr[0]} ${arr[1]} ${arr[0]}; then
      debug "Missing python package $i, requested build"
      return
    fi
  done
  DO_BUILD=0
}

# function called to build the source code
function build_python_packages() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  for i in ${REQUIREMENTS_python_packages[*]}
  do
    info "Installing python_packages package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the linked library version (e.g. hdf5)
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib \
    try $PIP $i
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_python_packages() {
 for i in ${REQUIREMENTS_python_packages[*]}
  do
    arr=(${i//==/ })
    if ! python_package_installed ${arr[0]} ${arr[1]} ${arr[0]} ; then
      error "Missing python package $i"
    fi
  done
}
