#!/bin/bash

DESC_protobuf="Protocol buffers (Google's data interchange format)"

# version of your package
VERSION_protobuf=22.3
LINK_protobuf_lite=libprotobuf-lite.22.3.0.dylib
LINK_protobuf=libprotobuf.22.3.0.dylib

# dependencies of this recipe
DEPS_protobuf=(zlib abseil_cpp)

# url of the package
URL_protobuf=https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION_protobuf}/protobuf-${VERSION_protobuf}.tar.gz

# md5 of the package
MD5_protobuf=1cea5c8535745a9f0f0bb584c5dc48a9

# default build path
BUILD_protobuf=$BUILD_PATH/protobuf/$(get_directory $URL_protobuf)

# default recipe path
RECIPE_protobuf=$RECIPES_PATH/protobuf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_protobuf() {
  cd $BUILD_protobuf

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_protobuf() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_protobuf_lite -nt $BUILD_protobuf/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_protobuf() {
  try mkdir -p $BUILD_PATH/protobuf/build-$ARCH
  try cd $BUILD_PATH/protobuf/build-$ARCH
  push_env

  try ${CMAKE} \
    -Dprotobuf_BUILD_LIBPROTOC=ON \
    -Dprotobuf_INSTALL_EXAMPLES=OFF \
    -Dprotobuf_BUILD_TESTS=OFF \
    -Dprotobuf_BUILD_SHARED_LIBS=ON \
    -Dprotobuf_ABSL_PROVIDER=package \
    $BUILD_protobuf
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  fix_install_name lib/$LINK_protobuf_lite
  fix_install_name lib/$LINK_protobuf
  fix_install_name lib/libprotoc.dylib
  fix_install_name bin/protoc

  pop_env
}

# function called after all the compile have been done
function postbuild_protobuf() {
  verify_binary lib/libprotobuf.dylib
  verify_binary lib/$LINK_protobuf_lite
  verify_binary lib/$LINK_protobuf
  verify_binary lib/libprotoc.dylib
  verify_binary bin/protoc
}

# function to append information to config file
function add_config_info_protobuf() {
  append_to_config_file "# protobuf-${VERSION_protobuf}: ${DESC_protobuf}"
  append_to_config_file "export VERSION_protobuf=${VERSION_protobuf}"
  append_to_config_file "export LINK_protobuf=${LINK_protobuf}"
  append_to_config_file "export LINK_protobuf_lite=${LINK_protobuf_lite}"
}