#!/bin/bash

DESC_python_pandas="python pandas"


DEPS_python_pandas=(python python_packages python_numpy)



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