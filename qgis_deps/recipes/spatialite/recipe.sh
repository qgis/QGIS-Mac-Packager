#!/bin/bash

DESC_spatialite="SpatiaLite database"

LINK_spatialite=libspatialite.7.dylib

DEPS_spatialite=(proj geos freexl libxml2 rttopo minizip)


# md5 of the package

# default build path
BUILD_spatialite=${DEPS_BUILD_PATH}/spatialite/$(get_directory $URL_spatialite)

# default recipe path
RECIPE_spatialite=$RECIPES_PATH/spatialite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_spatialite() {
  cd $BUILD_spatialite
  patch_configure_file configure
  try rsync -a $BUILD_spatialite/ ${DEPS_BUILD_PATH}/spatialite/build-${ARCH}
}

function shouldbuild_spatialite() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_spatialite -nt $BUILD_spatialite/.patched ]; then
    DO_BUILD=0
  fi
}

# function called after all the compile have been done
function postbuild_spatialite() {
  verify_binary lib/$LINK_spatialite
  verify_binary lib/mod_spatialite.so
}

# function to append information to config file
function add_config_info_spatialite() {
  append_to_config_file "# spatialite-${VERSION_spatialite}: ${DESC_spatialite}"
  append_to_config_file "export VERSION_spatialite=${VERSION_spatialite}"
  append_to_config_file "export LINK_spatialite=${LINK_spatialite}"
}