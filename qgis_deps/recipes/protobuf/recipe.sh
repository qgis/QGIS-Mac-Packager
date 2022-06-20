#!/bin/bash

DESC_protobuf="Protocol buffers (Google's data interchange format)"

LINK_protobuf_lite=libprotobuf-lite.30.dylib

DEPS_protobuf=(zlib)

# default build path
BUILD_protobuf=${DEPS_BUILD_PATH}/protobuf/$(get_directory $URL_protobuf)

# default recipe path
RECIPE_protobuf=$RECIPES_PATH/protobuf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_protobuf() {
  cd $BUILD_protobuf
  try rsync -a $BUILD_protobuf/ ${DEPS_BUILD_PATH}/protobuf/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_protobuf() {
  # verify_binary lib/libprotobuf.dylib
  # verify_binary lib/$LINK_protobuf
  verify_binary lib/$LINK_protobuf_lite
  verify_binary lib/libprotoc.dylib
  verify_binary bin/protoc
}

# function to append information to config file
function add_config_info_protobuf() {
  append_to_config_file "# protobuf-${VERSION_protobuf}: ${DESC_protobuf}"
  append_to_config_file "export VERSION_protobuf=${VERSION_protobuf}"
  # append_to_config_file "export LINK_protobuf=${LINK_protobuf}"
  append_to_config_file "export LINK_protobuf_lite=${LINK_protobuf_lite}"
}