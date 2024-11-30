#!/bin/bash

DESC_apache_arrow="Columnar in-memory analytics layer designed to accelerate big data"

# version of your package
VERSION_apache_arrow=12.0.1
LINK_apache_arrow_version=1200.1.0
LINK_apache_arrow=libarrow.${LINK_apache_arrow_version}1200.1.0.dylib

# dependencies of this recipe
DEPS_apache_arrow=(aws_sdk_cpp brotli bz2 glog grpc lz4 openssl protobuf rapidjson re2 snappy thrift utf8proc zstd)

# url of the package
URL_apache_arrow=https://archive.apache.org/dist/arrow/arrow-${VERSION_apache_arrow}/apache-arrow-${VERSION_apache_arrow}.tar.gz

# md5 of the package
MD5_apache_arrow=39e373a2148dedc49a0f7a716865734b

# default build path
BUILD_apache_arrow=$BUILD_PATH/apache_arrow/$(get_directory $URL_apache_arrow)

# default recipe path
RECIPE_apache_arrow=$RECIPES_PATH/apache_arrow

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_apache_arrow() {
  cd $BUILD_apache_arrow

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_apache_arrow() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_apache_arrow -nt $BUILD_apache_arrow/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_apache_arrow() {
  try mkdir -p $BUILD_PATH/apache_arrow/build-$ARCH
  try cd $BUILD_PATH/apache_arrow/build-$ARCH
  push_env

  try ${CMAKE} \
    -DCMAKE_INSTALL_RPATH=${STAGE_PATH} \
    -DARROW_ACERO=ON \
    -DARROW_COMPUTE=ON \
    -DARROW_CSV=ON \
    -DARROW_DATASET=ON \
    -DARROW_FILESYSTEM=ON \
    -DARROW_FLIGHT=ON \
    -DARROW_FLIGHT_SQL=ON \
    -DARROW_GANDIVA=ON \
    -DARROW_HDFS=ON \
    -DARROW_JSON=ON \
    -DARROW_ORC=ON \
    -DARROW_PARQUET=ON \
    -DARROW_PROTOBUF_USE_SHARED=ON \
    -DARROW_S3=ON \
    -DARROW_WITH_BZ2=ON \
    -DARROW_WITH_ZLIB=ON \
    -DARROW_WITH_ZSTD=ON \
    -DARROW_WITH_LZ4=ON \
    -DARROW_WITH_SNAPPY=ON \
    -DARROW_WITH_BROTLI=ON \
    -DARROW_WITH_UTF8PROC=ON \
    -DARROW_INSTALL_NAME_RPATH=OFF \
    $BUILD_apache_arrow
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libarrow*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_apache_arrow() {
  verify_binary lib/$LINK_apache_arrow
}

# function to append information to config file
function add_config_info_apache_arrow() {
  append_to_config_file "# apache_arrow-${VERSION_apache_arrow}: ${DESC_apache_arrow}"
  append_to_config_file "export VERSION_apache_arrow=${VERSION_apache_arrow}"
  append_to_config_file "export LINK_apache_arrow=${LINK_apache_arrow}"
}