#!/bin/bash

DESC_python_patsy="python patsy"

# version of your package
VERSION_python_patsy=0.5.3

# dependencies of this recipe
DEPS_python_patsy=(python python_packages python_numpy)

# url of the package
URL_python_patsy=https://github.com/pydata/patsy/archive/v${VERSION_python_patsy}.tar.gz

# md5 of the package
MD5_python_patsy=d80cade8ace4e653a842c3f43fa90a92

# default build path
BUILD_python_patsy=$BUILD_PATH/python_patsy/$(get_directory $URL_python_patsy)

# default recipe path
RECIPE_python_patsy=$RECIPES_PATH/python_patsy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_patsy() {
  cd $BUILD_python_patsy

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_patsy() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed patsy; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_patsy() {
  try rsync -a $BUILD_python_patsy/ $BUILD_PATH/python_patsy/build-$ARCH/
  try cd $BUILD_PATH/python_patsy/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
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