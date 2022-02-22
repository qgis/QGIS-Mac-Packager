#!/bin/bash

DESC_python_opencv="python opencv-contrib-python"
# source $RECIPES_PATH/python_numpy/recipe.sh

GIT_TAG_python_opencv=36

DEPS_python_opencv=(python python_packages python_numpy python_scipy openblas protobuf)


# md5 of the package

# default build path
BUILD_python_opencv=${DEPS_BUILD_PATH}/python_opencv/${GIT_TAG_python_opencv}

# default recipe path
RECIPE_python_opencv=$RECIPES_PATH/python_opencv

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_opencv() {
  mkdir -p $BUILD_python_opencv
  cd $BUILD_python_opencv

  cd ..
  # it has opencv,... submodules, so we cannot take it simply from the git release archive.
  git clone --recursive --depth 1 --branch $GIT_TAG_python_opencv https://github.com/skvark/opencv-python.git

  try rsync -a ${DEPS_BUILD_PATH}/python_opencv/opencv-python/ ${DEPS_BUILD_PATH}/python_opencv/build-$ARCH
}

function shouldbuild_python_opencv() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed cv2; then
    DO_BUILD=0
  fi
}



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