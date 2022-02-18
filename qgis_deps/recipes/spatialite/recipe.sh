#!/bin/bash

DESC_spatialite="SpatiaLite database"

# version of your package
VERSION_spatialite=5.0.1
LINK_spatialite=libspatialite.7.dylib

# dependencies of this recipe
DEPS_spatialite=(proj geos freexl libxml2 rttopo minizip)

# url of the package
URL_spatialite=https://www.gaia-gis.it/gaia-sins/libspatialite-${VERSION_spatialite}.tar.gz

# md5 of the package
MD5_spatialite=5f4a961afbb95dcdc715b5d7f8590573

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