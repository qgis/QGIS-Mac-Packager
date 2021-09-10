#!/bin/bash

DESC_proj_data="Cartographic proj library data"

# version of your package
VERSION_proj_data=1.7

# dependencies of this recipe
DEPS_proj_data=(proj)

# url of the package
URL_proj_data=http://ftp.osuosl.org/pub/osgeo/download/proj/proj-data-$VERSION_proj_data.tar.gz

# md5 of the package
MD5_proj_data=2ca6366e12cd9d34d73b4602049ee480

# default build path
BUILD_proj_data=$BUILD_PATH/proj_data/$(get_directory $URL_proj_data)

# default recipe path
RECIPE_proj_data=$RECIPES_PATH/proj_data

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj_data() {
  cd $BUILD_proj_data

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_proj_data() {
  if [ ${STAGE_PATH}/lib/${LINK_libproj_data} -nt $BUILD_proj_data/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_proj_data() {
  mkdir -p ${STAGE_PATH}/share/proj
  try cp -R $BUILD_proj_data/* ${STAGE_PATH}/share/proj/
}

# function called after all the compile have been done
function postbuild_proj_data() {
  :
}

# function to append information to config file
function add_config_info_proj_data() {
  append_to_config_file "# proj_data-${VERSION_proj_data}: ${DESC_proj_data}"
  append_to_config_file "export VERSION_proj_data=${VERSION_proj_data}"
}