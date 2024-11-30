#!/bin/bash

DESC_python_scikit_learn="python scikit-learn"

# version of your package
VERSION_python_scikit_learn=1.2.2

# dependencies of this recipe
DEPS_python_scikit_learn=(python python_packages python_numpy python_scipy libomp)

# url of the package
URL_python_scikit_learn=https://github.com/scikit-learn/scikit-learn/archive/${VERSION_python_scikit_learn}.tar.gz

# md5 of the package
MD5_python_scikit_learn=553a395c6a1d0bac55fa16e9dec32138

# default build path
BUILD_python_scikit_learn=$BUILD_PATH/python_scikit_learn/$(get_directory $URL_python_scikit_learn)

# default recipe path
RECIPE_python_scikit_learn=$RECIPES_PATH/python_scikit_learn

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_scikit_learn() {
  cd $BUILD_python_scikit_learn

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_scikit_learn() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed sklearn; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_scikit_learn() {
  try rsync -a $BUILD_python_scikit_learn/ $BUILD_PATH/python_scikit_learn/build-$ARCH/
  try cd $BUILD_PATH/python_scikit_learn/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}

# function called after all the compile have been done
function postbuild_python_scikit_learn() {
   if ! python_package_installed_verbose sklearn; then
      error "Missing python package sklearn"
   fi
}

# function to append information to config file
function add_config_info_python_scikit_learn() {
  append_to_config_file "# python_scikit_learn-${VERSION_python_scikit_learn}: ${DESC_python_scikit_learn}"
  append_to_config_file "export VERSION_python_scikit_learn=${VERSION_python_scikit_learn}"
}