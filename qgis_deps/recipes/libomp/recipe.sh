#!/bin/bash

DESC_libomp="LLVM's OpenMP runtime library"


LINK_libomp=libomp.dylib

DEPS_libomp=()


# md5 of the package

# default build path
BUILD_libomp=${DEPS_BUILD_PATH}/libomp/$(get_directory $URL_libomp)

# default recipe path
RECIPE_libomp=$RECIPES_PATH/libomp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libomp() {
  cd $BUILD_libomp


}

function shouldbuild_libomp() {
  if [ ${STAGE_PATH}/lib/${LINK_libomp} -nt $BUILD_libomp/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libomp() {
  verify_binary lib/$LINK_libomp
}

# function to append information to config file
function add_config_info_libomp() {
  append_to_config_file "# libomp-${VERSION_libomp}: ${DESC_libomp}"
  append_to_config_file "export VERSION_libomp=${VERSION_libomp}"
  append_to_config_file "export LINK_libomp=${LINK_libomp}"
}