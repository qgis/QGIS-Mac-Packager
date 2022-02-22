#!/bin/bash

DESC_freexl="Library to extract data from Excel .xls files"

LINK_freexl=libfreexl.1.dylib

DEPS_freexl=()


# md5 of the package

# default build path
BUILD_freexl=${DEPS_BUILD_PATH}/freexl/$(get_directory $URL_freexl)

# default recipe path
RECIPE_freexl=$RECIPES_PATH/freexl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freexl() {
  cd $BUILD_freexl

    patch_configure_file configure
  try rsync   -a $BUILD_freexl/ ${DEPS_BUILD_PATH}/freexl/build-$ARCH/
}

function shouldbuild_freexl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_freexl -nt $BUILD_freexl/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_freexl() {
  verify_binary lib/$LINK_freexl
}

# function to append information to config file
function add_config_info_freexl() {
  append_to_config_file "# freexl-${VERSION_freexl}: ${DESC_freexl}"
  append_to_config_file "export VERSION_freexl=${VERSION_freexl}"
  append_to_config_file "export LINK_freexl=${LINK_freexl}"
}
