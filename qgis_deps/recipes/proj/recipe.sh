#!/bin/bash

DESC_proj="Cartographic Projections Library"

# version of your package
# keep in SYNC with python_pyproj receipt
VERSION_proj=8.2.1

LINK_libproj=libproj.22.dylib

# dependencies of this recipe
DEPS_proj=(sqlite libxml2 openssl libtiff)

# url of the package
URL_proj=https://github.com/OSGeo/PROJ/releases/download/$VERSION_proj/proj-$VERSION_proj.tar.gz

# md5 of the package
MD5_proj=03ed0375ba8c9dd245bdbbf40ed7a786

# default build path
BUILD_proj=${DEPS_BUILD_PATH}/proj/$(get_directory $URL_proj)

# default recipe path
RECIPE_proj=$RECIPES_PATH/proj

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj() {
  cd $BUILD_proj


}

function shouldbuild_proj() {
  if [ ${STAGE_PATH}/lib/${LINK_libproj} -nt $BUILD_proj/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_proj() {
  verify_binary lib/$LINK_libproj

  verify_binary bin/proj
}

# function to append information to config file
function add_config_info_proj() {
  append_to_config_file "# proj-${VERSION_proj}: ${DESC_proj}"
  append_to_config_file "export VERSION_proj=${VERSION_proj}"
  append_to_config_file "export LINK_libproj=${LINK_libproj}"
}