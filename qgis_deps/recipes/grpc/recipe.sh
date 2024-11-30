#!/bin/bash

DESC_grpc="Next generation open source RPC library and framework"

# version of your package
VERSION_grpc=1.56.2
LINK_grpc_version=1.56.2
LINK_grpc=libgrpc++.${LINK_grpc_version}.dylib

# dependencies of this recipe
DEPS_grpc=(abseil_cpp c_ares openssl protobuf re2)

# url of the package
URL_grpc=https://github.com/grpc/grpc/archive/refs/tags/v${VERSION_grpc}.tar.gz

# md5 of the package
MD5_grpc=be0c4a589168ac0669a10a3bcbf64a1d

# default build path
BUILD_grpc=$BUILD_PATH/grpc/$(get_directory $URL_grpc)

# default recipe path
RECIPE_grpc=$RECIPES_PATH/grpc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_grpc() {
  cd $BUILD_grpc

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_grpc() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_grpc -nt $BUILD_grpc/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_grpc() {
  try mkdir -p $BUILD_PATH/grpc/build-$ARCH
  try cd $BUILD_PATH/grpc/build-$ARCH
  push_env

  try ${CMAKE} \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_CXX_STANDARD_REQUIRED=TRUE \
    -DBUILD_SHARED_LIBS=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DgRPC_INSTALL=ON \
    -DgRPC_ABSL_PROVIDER=package \
    -DgRPC_CARES_PROVIDER=package \
    -DgRPC_PROTOBUF_PROVIDER=package \
    -DgRPC_SSL_PROVIDER=package \
    -DgRPC_ZLIB_PROVIDER=package \
    -DgRPC_RE2_PROVIDER=package \
    $BUILD_grpc
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libgrpc*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_grpc() {
  verify_binary lib/$LINK_grpc
}

# function to append information to config file
function add_config_info_grpc() {
  append_to_config_file "# grpc-${VERSION_grpc}: ${DESC_grpc}"
  append_to_config_file "export VERSION_grpc=${VERSION_grpc}"
  append_to_config_file "export LINK_grpc=${LINK_grpc}"
}