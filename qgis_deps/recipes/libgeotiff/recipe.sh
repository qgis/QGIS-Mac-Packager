#!/bin/bash

DESC_libgeotiff="Library and tools for dealing with GeoTIFF"


DEPS_libgeotiff=(proj libtiff)


# md5 of the package

# default build path
BUILD_libgeotiff=${DEPS_BUILD_PATH}/libgeotiff/$(get_directory $URL_libgeotiff)

# default recipe path
RECIPE_libgeotiff=$RECIPES_PATH/libgeotiff

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libgeotiff() {
  cd $BUILD_libgeotiff


}

# function called before build_libgeotiff
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libgeotiff() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/libgeotiff.a" -nt $BUILD_libgeotiff/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libgeotiff() {
  verify_binary "lib/libgeotiff.a"
}

# function to append information to config file
function add_config_info_libgeotiff() {
  append_to_config_file "# libgeotiff-${VERSION_libgeotiff}: ${DESC_libgeotiff}"
  append_to_config_file "export VERSION_libgeotiff=${VERSION_libgeotiff}"
}