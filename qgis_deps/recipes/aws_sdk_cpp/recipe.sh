#!/bin/bash

DESC_aws_sdk_cpp="AWS SDK for C++"

# version of your package
VERSION_aws_sdk_cpp=1.11.193
LINK_aws_sdk_cpp=libaws-cpp-sdk-ec2.dylib

# dependencies of this recipe
DEPS_aws_sdk_cpp=()

# url of the package
URL_aws_sdk_cpp=https://github.com/aws/aws-sdk-cpp/archive/refs/tags/${VERSION_aws_sdk_cpp}.tar.gz

# md5 of the package
MD5_aws_sdk_cpp=eaec3122c7b8e48b8b68cd7d2cde8862

# default build path
BUILD_aws_sdk_cpp=$BUILD_PATH/aws_sdk_cpp/$(get_directory $URL_aws_sdk_cpp)

# default recipe path
RECIPE_aws_sdk_cpp=$RECIPES_PATH/aws_sdk_cpp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_aws_sdk_cpp() {
  cd $BUILD_aws_sdk_cpp
  echo "Test!!"
  echo $BUILD_aws_sdk_cpp

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # need to clone recursively
  git clone --recursive https://github.com/aws/aws-sdk-cpp.git -b ${VERSION_aws_sdk_cpp} --depth 1

  touch .patched
}

function shouldbuild_aws_sdk_cpp() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_aws_sdk_cpp -nt $BUILD_aws_sdk_cpp/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_aws_sdk_cpp() {
  try mkdir -p $BUILD_PATH/aws_sdk_cpp/build-$ARCH
  try cd $BUILD_PATH/aws_sdk_cpp/build-$ARCH
  push_env

  try ${CMAKE} \
    -DENABLE_TESTING=OFF \
    $BUILD_aws_sdk_cpp/aws-sdk-cpp
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libaws*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_aws_sdk_cpp() {
  verify_binary lib/$LINK_aws_sdk_cpp
}

# function to append information to config file
function add_config_info_aws_sdk_cpp() {
  append_to_config_file "# aws_sdk_cpp-${VERSION_aws_sdk_cpp}: ${DESC_aws_sdk_cpp}"
  append_to_config_file "export VERSION_aws_sdk_cpp=${VERSION_aws_sdk_cpp}"
  append_to_config_file "export LINK_aws_sdk_cpp=${LINK_aws_sdk_cpp}"
}