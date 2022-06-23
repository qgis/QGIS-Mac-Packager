#!/bin/bash

DESC_python_pubsub="A Python publish-subcribe library"

# need to keep in sync with compatible version of netcdf lib

DEPS_python_pubsub=(python python_packages)

# default build path
BUILD_python_pubsub=${DEPS_BUILD_PATH}/python_pubsub/$(get_directory $URL_python_pubsub)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pubsub() {
  mkdir -p $BUILD_python_pubsub
  cd $BUILD_python_pubsub
  try rsync -a $BUILD_python_pubsub/ ${DEPS_BUILD_PATH}/python_pubsub/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pubsub() {
   if ! python_package_installed_verbose pubsub; then
      error "Missing python package pubsub"
   fi
}

# function to append information to config file
function add_config_info_python_pubsub() {
  append_to_config_file "# python_pubsub-${VERSION_python_pubsub}: ${DESC_python_pubsub}"
  append_to_config_file "export VERSION_python_pubsub=${VERSION_python_pubsub}"
}