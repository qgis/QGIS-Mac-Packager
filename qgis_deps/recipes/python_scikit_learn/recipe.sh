#!/bin/bash

DESC_python_scikit_learn="python scikit-learn"

# version of your package
VERSION_python_scikit_learn=0.23.1

# dependencies of this recipe
DEPS_python_scikit_learn=(python python_packages python_numpy python_scipy libomp)

# url of the package
URL_python_scikit_learn=https://github.com/scikit-learn/scikit-learn/archive/${VERSION_python_scikit_learn}.tar.gz

# md5 of the package
MD5_python_scikit_learn=f7f33cfdb020c4ff07e97f66a6085782

# default build path
BUILD_python_scikit_learn=${DEPS_BUILD_PATH}/python_scikit_learn/$(get_directory $URL_python_scikit_learn)

# default recipe path
RECIPE_python_scikit_learn=$RECIPES_PATH/python_scikit_learn

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_scikit_learn() {
  cd $BUILD_python_scikit_learn
  try rsync -a $BUILD_python_scikit_learn/ ${DEPS_BUILD_PATH}/python_scikit_learn/build-${ARCH}


}

function shouldbuild_python_scikit_learn() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed sklearn; then
    DO_BUILD=0
  fi
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