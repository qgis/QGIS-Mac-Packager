#!/bin/bash

DESC_python_pandas="python pandas"

# version of your package
VERSION_python_pandas=1.3.3

# dependencies of this recipe
DEPS_python_pandas=(python python_packages python_numpy)

# url of the package
URL_python_pandas=https://github.com/pandas-dev/pandas/archive/refs/tags/v${VERSION_python_pandas}.tar.gz

# md5 of the package
MD5_python_pandas=413a3efbd23832d48517b3091ff44800

# default build path
BUILD_python_pandas=${DEPS_BUILD_PATH}/python_pandas/$(get_directory $URL_python_pandas)

# default recipe path
RECIPE_python_pandas=$RECIPES_PATH/python_pandas

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pandas() {
  cd $BUILD_python_pandas
  try rsync -a $BUILD_python_pandas/ ${DEPS_BUILD_PATH}/python_pandas/build-${ARCH}
}

function shouldbuild_python_pandas() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed pandas; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_pandas() {
   if ! python_package_installed_verbose pandas; then
      error "Missing python package pandas"
   fi
}

# function to append information to config file
function add_config_info_python_pandas() {
  append_to_config_file "# python_pandas-${VERSION_python_pandas}: ${DESC_python_pandas}"
  append_to_config_file "export VERSION_python_pandas=${VERSION_python_pandas}"
}