#!/bin/bash

DESC_geos="Geometry Engine"

# version of your package
VERSION_geos=3.10.2

LINK_libgeos_c=libgeos_c.1.dylib
LINK_libgeos=libgeos.${VERSION_geos}.dylib

# dependencies of this recipe
DEPS_geos=()

# url of the package
URL_geos=http://download.osgeo.org/geos/geos-${VERSION_geos}.tar.bz2

# md5 of the package
MD5_geos=324258ae27b5d53cd90897435d97cc6a

# default build path
BUILD_geos=$BUILD_PATH/geos/$(get_directory $URL_geos)

# default recipe path
RECIPE_geos=$RECIPES_PATH/geos

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geos() {
  cd $BUILD_geos


}

function shouldbuild_geos() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libgeos_c} -nt $BUILD_geos/.patched ]; then
    DO_BUILD=0
  fi
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