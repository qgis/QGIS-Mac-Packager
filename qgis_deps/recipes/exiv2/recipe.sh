#!/bin/bash

DESC_exiv2="EXIF and IPTC metadata manipulation library and tools"

# version of your package
VERSION_exiv2=0.27.3
LINK_exiv2=libexiv2.27.dylib

# dependencies of this recipe
DEPS_exiv2=()

# url of the package
URL_exiv2=https://github.com/Exiv2/exiv2/releases/download/v${VERSION_exiv2}/exiv2-${VERSION_exiv2}-Source.tar.gz

# md5 of the package
MD5_exiv2=68a59595e8617284b2e1eee528ae1f77

# default build path
BUILD_exiv2=$BUILD_PATH/exiv2/$(get_directory $URL_exiv2)

# default recipe path
RECIPE_exiv2=$RECIPES_PATH/exiv2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_exiv2() {
  cd $BUILD_exiv2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_exiv2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_exiv2 -nt $BUILD_exiv2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_exiv2() {
  try mkdir -p $BUILD_PATH/exiv2/build-$ARCH
  try cd $BUILD_PATH/exiv2/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_exiv2
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  pop_env
}

# function called after all the compile have been done
function postbuild_exiv2() {
  verify_binary lib/$LINK_exiv2
  verify_binary bin/addmoddel
}

# function to append information to config file
function add_config_info_exiv2() {
  append_to_config_file "# exiv2-${VERSION_exiv2}: ${DESC_exiv2}"
  append_to_config_file "export VERSION_exiv2=${VERSION_exiv2}"
  append_to_config_file "export LINK_exiv2=${LINK_exiv2}"
}