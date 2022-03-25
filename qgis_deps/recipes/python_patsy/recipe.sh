#!/bin/bash

DESC_python_patsy="python patsy"


DEPS_python_patsy=(python python_packages python_numpy)


# default build path
BUILD_python_patsy=${DEPS_BUILD_PATH}/python_patsy/$(get_directory $URL_python_patsy)

# default recipe path
RECIPE_python_patsy=$RECIPES_PATH/python_patsy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_patsy() {
  cd $BUILD_python_patsy
  try rsync -a $BUILD_python_patsy/ ${DEPS_BUILD_PATH}/python_patsy/build-${ARCH}


}

function shouldbuild_python_patsy() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed patsy; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_patsy() {
   if ! python_package_installed_verbose patsy; then
      error "Missing python package patsy"
   fi
}

# function to append information to config file
function add_config_info_python_patsy() {
  append_to_config_file "# python_patsy-${VERSION_python_patsy}: ${DESC_python_patsy}"
  append_to_config_file "export VERSION_python_patsy=${VERSION_python_patsy}"
}