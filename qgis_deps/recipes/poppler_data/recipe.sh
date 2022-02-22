#!/bin/bash

DESC_poppler_data="Poppler encoding data"


DEPS_poppler_data=()


# md5 of the package

# default build path
BUILD_poppler_data=${DEPS_BUILD_PATH}/poppler_data/$(get_directory ${URL_poppler_data})

# default recipe path
RECIPE_poppler_data=${RECIPES_PATH}/poppler_data

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_poppler_data() {
  cd ${BUILD_poppler_data}
}

function shouldbuild_poppler_data() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_poppler_data} -nt ${BUILD_poppler_data}/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_poppler_data() {
  :
}

# function to append information to config file
function add_config_info_poppler_data() {
  :
}