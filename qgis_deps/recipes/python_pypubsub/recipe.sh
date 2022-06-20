#!/bin/bash

DESC_python_pypubsub="A Python publish-subcribe library"

# need to keep in sync with compatible version of netcdf lib

DEPS_python_pypubsub=(python python_packages)

# default build path
BUILD_python_pypubsub=${DEPS_BUILD_PATH}/python_pypubsub/$(get_directory $URL_python_pypubsub)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pypubsub() {
  mkdir -p $BUILD_python_pypubsub
  cd $BUILD_python_pypubsub
  try rsync -a $BUILD_python_pypubsub/ ${DEPS_BUILD_PATH}/python_pypubsub/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pypubsub() {
   if ! python_package_installed_verbose pypubsub; then
      error "Missing python package pypubsub"
   fi
}

# function to append information to config file
function add_config_info_python_pypubsub() {
  append_to_config_file "# python_pypubsub-${VERSION_python_pypubsub}: ${DESC_python_pypubsub}"
  append_to_config_file "export VERSION_python_pypubsub=${VERSION_python_pypubsub}"
}