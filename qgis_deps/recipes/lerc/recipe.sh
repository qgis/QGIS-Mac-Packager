#!/bin/bash

DESC_lerc="Limited Error Raster Compression"

# version of your package
VERSION_lerc=3.0

LINK_liblerc=libLerc.dylib

# dependencies of this recipe
DEPS_lerc=()

# url of the package
URL_lerc=https://github.com/Esri/lerc/archive/refs/tags/v$VERSION_lerc.tar.gz

# md5 of the package
MD5_lerc=916567b67ca55ae037b826717b5940ec

# default build path
BUILD_lerc=$BUILD_PATH/lerc/$(get_directory $URL_lerc)

# default recipe path
RECIPE_lerc=$RECIPES_PATH/lerc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_lerc() {
  cd $BUILD_lerc


}

function shouldbuild_lerc() {
  if [ ${STAGE_PATH}/lib/${LINK_liblerc} -nt $BUILD_lerc/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_lerc() {
  verify_binary lib/$LINK_liblerc
}

# function to append information to config file
function add_config_info_lerc() {
  append_to_config_file "# lerc-${VERSION_lerc}: ${DESC_lerc}"
  append_to_config_file "export VERSION_lerc=${VERSION_lerc}"
  append_to_config_file "export LINK_liblerc=${LINK_liblerc}"
}