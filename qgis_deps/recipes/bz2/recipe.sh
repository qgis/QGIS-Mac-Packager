#!/bin/bash

DESC_bz2="Portable Foreign Function Interface library"

LINK_bz2=libbz2.$VERSION_bz2_major.dylib

DEPS_bz2=()


# md5 of the package

# default build path
BUILD_bz2=${DEPS_BUILD_PATH}/bz2/$(get_directory $URL_bz2)

# default recipe path
RECIPE_bz2=$RECIPES_PATH/bz2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_bz2() {
  cd $BUILD_bz2
  try rsync -a $BUILD_bz2/ ${DEPS_BUILD_PATH}/bz2/build-${ARCH}
}

function shouldbuild_bz2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_bz2 -nt $BUILD_bz2/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_bz2() {
  verify_binary lib/$LINK_bz2
}

# function to append information to config file
function add_config_info_bz2() {
  append_to_config_file "# bz2-${VERSION_bz2}: ${DESC_bz2}"
  append_to_config_file "export VERSION_bz2=${VERSION_bz2}"
  append_to_config_file "export LINK_bz2=${LINK_bz2}"
}