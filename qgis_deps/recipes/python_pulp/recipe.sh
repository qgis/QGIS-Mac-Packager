#!/bin/bash

DESC_python_pulp="A python Linear Programming API"

DEPS_python_pulp=(
)

# default build path
BUILD_python_pulp=${DEPS_BUILD_PATH}/python_pulp/$(get_directory ${URL_python_pulp})

# default recipe path
RECIPE_python_pulp=$RECIPES_PATH/python_pulp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pulp() {
  cd $BUILD_python_pulp
  try rsync -a $BUILD_python_pulp/ ${DEPS_BUILD_PATH}/python_pulp/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pulp() {
   if ! python_package_installed_verbose pulp; then
      error "Missing python package pulp"
   fi
}

# function to append information to config file
function add_config_info_python_pulp() {
  append_to_config_file "# python_pulp-${VERSION_python_pulp}: ${DESC_python_pulp}"
  append_to_config_file "export VERSION_python_pulp=${VERSION_python_pulp}"
}