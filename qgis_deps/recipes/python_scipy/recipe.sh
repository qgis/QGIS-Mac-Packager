#!/bin/bash

DESC_python_scipy="python scipy"

# version of your package
VERSION_python_scipy=1.5.1

# dependencies of this recipe
DEPS_python_scipy=(python python_packages python_numpy python_pillow openblas)

# url of the package
URL_python_scipy=https://github.com/scipy/scipy/archive/v${VERSION_python_scipy}.tar.gz

# md5 of the package
MD5_python_scipy=d7653c3b9af520d97d93877469eec305

# default build path
BUILD_python_scipy=$BUILD_PATH/python_scipy/$(get_directory $URL_python_scipy)

# default recipe path
RECIPE_python_scipy=$RECIPES_PATH/python_scipy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_scipy() {
  cd $BUILD_python_scipy
  try rsync -a $BUILD_python_scipy/ ${BUILD_PATH}/python_scipy/build-${ARCH}


}

function shouldbuild_python_scipy() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed scipy; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_scipy() {
  if ! python_package_installed_verbose scipy; then
    error "Missing python package scipy"
  fi
}

# function to append information to config file
function add_config_info_python_scipy() {
  append_to_config_file "# python_scipy-${VERSION_python_scipy}: ${DESC_python_scipy}"
  append_to_config_file "export VERSION_python_scipy=${VERSION_python_scipy}"
}
