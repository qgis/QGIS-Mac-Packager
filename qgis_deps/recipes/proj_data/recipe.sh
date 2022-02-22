#!/bin/bash

DESC_proj_data="Cartographic proj library data"



VERSION_proj_data_major=$(echo ${VERSION_proj_data} | gsed -r 's/([0-9]+\.[0-9]+)(\.[0-9]+)?/\1/')

DEPS_proj_data=(proj)


# md5 of the package

# default build path
BUILD_proj_data=${DEPS_BUILD_PATH}/proj_data/$(get_directory $URL_proj_data)

# default recipe path
RECIPE_proj_data=$RECIPES_PATH/proj_data

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj_data() {
  cd $BUILD_proj_data
}

function shouldbuild_proj_data() {
  if [ ${STAGE_PATH}/share/proj/README.DATA -nt $BUILD_proj_data/.patched ]; then
    DO_BUILD=0
  fi
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