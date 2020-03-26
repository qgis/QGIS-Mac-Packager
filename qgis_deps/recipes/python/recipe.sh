#!/bin/bash

# version of your package (set in config.conf)
VERSION_python=${VERSION_python}

# dependencies of this recipe
DEPS_python=()

# url of the package
URL_python=

# md5 of the package
MD5_python=

# default build path
BUILD_python=$BUILD_PATH/python/v${VERSION_python}

# default recipe path
RECIPE_python=$RECIPES_PATH/python

# requirements
REQUIREMENTS_python=(
  numpy==1.18.2
  h5py==2.10.0
  requests==2.23.0
)

patch_python_linker_links () {
  targets=(
    $QGIS_SITE_PACKAGES_PATH/h5py/_errors.cpython-37m-darwin.so
  )

  for i in ${targets[*]}
  do
      install_name_tool -add_rpath @loader_path/../../../ $i
  done
}

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
  for i in ${REQUIREMENTS_python[*]}
  do
    arr=(${i//==/ })
    if ! python_package_installed ${arr[0]}; then
      debug "Missing python package $i, requested build"
      return
    fi
  done
  DO_BUILD=0
}

# function called to build the source code
function build_python() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  for i in ${REQUIREMENTS_python[*]}
  do
    info "Installing python package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP $i
  done

  patch_python_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_python() {
 for i in ${REQUIREMENTS_python[*]}
  do
    arr=(${i//==/ })
    if ! python_package_installed ${arr[0]} ; then
      error "Missing python package $i"
    fi
  done
}
