function build_python_opencv() {
  try mkdir -p ${DEPS_BUILD_PATH}/python_opencv/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/python_opencv/

  push_env

  # it has opencv,... submodules, so we cannot take it simply from the git release archive.
  git clone --recursive --depth 1 --branch $GIT_TAG_python_opencv https://github.com/skvark/opencv-python.git

  try rsync -a ${DEPS_BUILD_PATH}/python_opencv/opencv-python/ ${DEPS_BUILD_PATH}/python_opencv/build-$ARCH

  try cd ${DEPS_BUILD_PATH}/python_opencv/build-$ARCH

  export CMAKE_ARGS=""
  export CMAKE_ARGS="-DCMAKE_PREFIX_PATH=$STAGE_PATH;$QT_BASE/clang_64"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_MACOSX_RPATH=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DPROTOBUF_UPDATE_FILES=TRUE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_PROTOBUF=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_ZLIB=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_TIFF=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_JPEG=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_PNG=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_WEBP=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DWITH_FFMPEG=FALSE"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET"
  export CMAKE_ARGS="${CMAKE_ARGS} -GNinja -DCMAKE_MAKE_PROGRAM=$NINJA"

  export ENABLE_CONTRIB=1
  try $PYTHON setup.py install

  unset ENABLE_CONTRIB
  unset CMAKE_ARGS
  pop_env
}
