#!/bin/bash

DESC_python_opencv="python opencv-contrib-python"
# source $RECIPES_PATH/python_numpy/recipe.sh

DEPS_python_opencv=(
  python
  python_packages
  python_numpy
  python_scipy
  python_scikit_build
  openblas
  protobuf)

# default build path
BUILD_python_opencv=${DEPS_BUILD_PATH}/python_opencv/${GIT_TAG_python_opencv}

# default recipe path
RECIPE_python_opencv=$RECIPES_PATH/python_opencv

# function called after all the compile have been done
function postbuild_python_opencv() {
   if ! python_package_installed_verbose cv2; then
      error "Missing python package opencv-contrib-python"
   fi
}

# function to append information to config file
function add_config_info_python_opencv() {
  append_to_config_file "# python_opencv-${VERSION_python_opencv}: ${DESC_python_opencv}"
  append_to_config_file "export VERSION_python_opencv=${VERSION_python_opencv}"
}
