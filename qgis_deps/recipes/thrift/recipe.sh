#!/bin/bash

DESC_thrift="Framework for scalable cross-language services development"

# version of your package
VERSION_thrift=0.19.0
LINK_thrift_version=0.19.0
LINK_thrift=libthrift.${LINK_thrift_version}.dylib
LINK_thriftz=libthriftz.${LINK_thrift_version}.dylib

# dependencies of this recipe
DEPS_thrift=(bison boost openssl zlib)

# url of the package
URL_thrift=https://archive.apache.org/dist/thrift/${VERSION_thrift}/thrift-${VERSION_thrift}.tar.gz

# md5 of the package
MD5_thrift=f2074232cd80c83f30c030cb69ef68a8

# default build path
BUILD_thrift=$BUILD_PATH/thrift/$(get_directory $URL_thrift)

# default recipe path
RECIPE_thrift=$RECIPES_PATH/thrift

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_thrift() {
  cd $BUILD_thrift

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_thrift() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_thrift -nt $BUILD_thrift/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_thrift() {
  try cd $BUILD_thrift
  push_env

  export PATH=${STAGE_PATH}/bin:$PATH # for bison
  try ./bootstrap.sh

  # Don't install extensions to /usr:
  export PY_PREFIX=${STAGE_PATH}
  export PHP_PREFIX=${STAGE_PATH}
  export JAVA_PREFIX=${STAGE_PATH}

  try ${CONFIGURE} \
    --disable-debug \
    --disable-tests \
    --with-openssl=${STAGE_PATH} \
    --without-java \
    --without-kotlin \
    --without-python \
    --without-py3 \
    --without-ruby \
    --without-haxe \
    --without-netstd \
    --without-perl \
    --without-php \
    --without-php_extension \
    --without-dart \
    --without-erlang \
    --without-go \
    --without-d \
    --without-nodejs \
    --without-nodets \
    --without-lua \
    --without-rs \
    --without-swift

  try $MAKESMP
  try $MAKESMP install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libthrift*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_thrift() {
  verify_binary lib/$LINK_thrift
  verify_binary lib/$LINK_thriftz
}

# function to append information to config file
function add_config_info_thrift() {
  append_to_config_file "# thrift-${VERSION_thrift}: ${DESC_thrift}"
  append_to_config_file "export VERSION_thrift=${VERSION_thrift}"
  append_to_config_file "export LINK_thrift=${LINK_thrift}"
}