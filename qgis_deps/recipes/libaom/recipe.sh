#!/bin/bash

DESC_libaom="LLVM's OpenMP runtime library"

# version of your package
VERSION_libaom=3.3.0

LINK_libaom=libaom.3.dylib

# dependencies of this recipe
DEPS_libaom=()

# url of the package
URL_libaom=https://aomedia.googlesource.com/aom/+archive/v${VERSION_libaom}.tar.gz

# md5 of the package
MD5_libaom=424a0abcd1953459eb04c1753e1fc138

# default build path
BUILD_libaom=${BUILD_PATH}/libaom/$(get_directory $URL_libaom)

# default recipe path
RECIPE_libaom=$RECIPES_PATH/libaom

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libaom() {
  cd $BUILD_libaom
}

function shouldbuild_libaom() {
  if [ ${STAGE_PATH}/lib/${LINK_libaom} -nt $BUILD_libaom/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libaom() {
  verify_binary lib/$LINK_libaom
}

# function to append information to config file
function add_config_info_libaom() {
  append_to_config_file "# libaom-${VERSION_libaom}: ${DESC_libaom}"
  append_to_config_file "export VERSION_libaom=${VERSION_libaom}"
  append_to_config_file "export LINK_libaom=${LINK_libaom}"
}