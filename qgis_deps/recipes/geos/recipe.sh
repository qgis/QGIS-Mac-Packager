#!/bin/bash

DESC_geos="Geometry Engine"


LINK_libgeos_c=libgeos_c.1.dylib
LINK_libgeos=libgeos.${VERSION_geos}.dylib

DEPS_geos=()


# md5 of the package

# default build path
BUILD_geos=${DEPS_BUILD_PATH}/geos/$(get_directory $URL_geos)

# default recipe path
RECIPE_geos=$RECIPES_PATH/geos

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geos() {
  cd $BUILD_geos
}

# function called after all the compile have been done
function postbuild_geos() {
  verify_binary lib/${LINK_libgeos_c}
  verify_binary lib/${LINK_libgeos}
}

# function to append information to config file
function add_config_info_geos() {
  append_to_config_file "# geos-${VERSION_geos}: ${DESC_geos}"
  append_to_config_file "export VERSION_geos=${VERSION_geos}"
  append_to_config_file "export LINK_libgeos_c=${LINK_libgeos_c}"
  append_to_config_file "export LINK_libgeos=${LINK_libgeos}"
}