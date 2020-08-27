#!/bin/bash

DESC_python_opencv="python opencv-contrib-python"
# source $RECIPES_PATH/python_numpy/recipe.sh

# version of your package
GIT_TAG_python_opencv=36
VERSION_python_opencv=4.3.0.${GIT_TAG_python_opencv}

# dependencies of this recipe
DEPS_python_opencv=(python python_packages python_numpy python_scipy openblas protobuf)

# url of the package
URL_python_opencv=

# md5 of the package
MD5_python_opencv=

# default build path
BUILD_python_opencv=$BUILD_PATH/python_opencv/${GIT_TAG_python_opencv}

# default recipe path
RECIPE_python_opencv=$RECIPES_PATH/python_opencv

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_opencv() {
  mkdir -p $BUILD_python_opencv
  cd $BUILD_python_opencv

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched

  cd ..
  # it has opencv,... submodules, so we cannot take it simply from the git release archive.
  git clone --recursive --depth 1 --branch $GIT_TAG_python_opencv https://github.com/skvark/opencv-python.git
}

function shouldbuild_python_opencv() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed cv2; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_opencv() {
  try rsync -a $BUILD_PATH/python_opencv/opencv-python/ $BUILD_PATH/python_opencv/build-$ARCH/
  try cd $BUILD_PATH/python_opencv/build-$ARCH
  push_env

  export CMAKE_ARGS=""
  export CMAKE_ARGS="-DCMAKE_PREFIX_PATH=$STAGE_PATH;$QT_BASE/clang_64"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_MACOSX_RPATH=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_PROTOBUF=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DPROTOBUF_UPDATE_FILES=TRUE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_ZLIB=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_TIFF=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_JPEG=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_PNG=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DBUILD_WEBP=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET"
  export CMAKE_ARGS="${CMAKE_ARGS} -GNinja -DCMAKE_MAKE_PROGRAM=$NINJA"

  export ENABLE_CONTRIB=1
  try $PYTHON setup.py install

  unset ENABLE_CONTRIB
  unset CMAKE_ARGS
  pop_env
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