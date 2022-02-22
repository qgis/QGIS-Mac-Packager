#!/bin/bash

DESC_spatialindex="General framework for developing spatial indices"


LINK_spatialindex=libspatialindex.6.dylib
LINK_spatialindex_c=libspatialindex_c.6.1.1.dylib

DEPS_spatialindex=()


# md5 of the package

# default build path
BUILD_spatialindex=${DEPS_BUILD_PATH}/spatialindex/$(get_directory $URL_spatialindex)

# default recipe path
RECIPE_spatialindex=$RECIPES_PATH/spatialindex

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_spatialindex() {
  cd $BUILD_spatialindex


  # remove in release 1.9.4
  # see https://github.com/libspatialindex/libspatialindex/commit/387a5a07d4f7ab6d94d9f3aaf728f5cc81b2d944
  try patch --verbose --forward -p1 < $RECIPE_spatialindex/patches/temporaryfile.patch

}

function shouldbuild_spatialindex() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_spatialindex -nt $BUILD_spatialindex/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_spatialindex() {
  verify_binary lib/$LINK_spatialindex
  verify_binary lib/$LINK_spatialindex_c
}

# function to append information to config file
function add_config_info_spatialindex() {
  append_to_config_file "# spatialindex-${VERSION_spatialindex}: ${DESC_spatialindex}"
  append_to_config_file "export VERSION_spatialindex=${VERSION_spatialindex}"
  append_to_config_file "export LINK_spatialindex=${LINK_spatialindex}"
  append_to_config_file "export LINK_spatialindex_c=${LINK_spatialindex_c}"
}