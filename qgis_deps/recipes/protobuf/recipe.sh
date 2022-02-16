#!/bin/bash

DESC_protobuf="Protocol buffers (Google's data interchange format)"

# version of your package
VERSION_protobuf=3.19.4
LINK_protobuf_lite=libprotobuf-lite.30.dylib

# dependencies of this recipe
DEPS_protobuf=(zlib)

# url of the package
URL_protobuf=https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION_protobuf}/protobuf-cpp-${VERSION_protobuf}.tar.gz

# md5 of the package
MD5_protobuf=ccedd5b7b09a9eda37e8654155baca5a

# default build path
BUILD_protobuf=$BUILD_PATH/protobuf/$(get_directory $URL_protobuf)

# default recipe path
RECIPE_protobuf=$RECIPES_PATH/protobuf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_protobuf() {
  cd $BUILD_protobuf
  try rsync -a $BUILD_protobuf/ ${BUILD_PATH}/protobuf/build-${ARCH}


}

function shouldbuild_protobuf() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_protobuf_lite -nt $BUILD_protobuf/.patched ]; then
    DO_BUILD=0
  fi
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