#!/bin/bash

DESC_xerces="Validating XML parser written in a portable subset of C++"


LINK_libxerces_c=libxerces-c-3.2.dylib
DEPS_xerces=(expat libcurl libicu)

# default build path
BUILD_xerces=${DEPS_BUILD_PATH}/xerces/$(get_directory $URL_xerces)

# default recipe path
RECIPE_xerces=$RECIPES_PATH/xerces

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xerces() {
  cd $BUILD_xerces
}

# function called after all the compile have been done
function postbuild_xerces() {
  verify_binary lib/${LINK_libxerces_c}
  verify_binary bin/CreateDOMDocument
}

# function to append information to config file
function add_config_info_xerces() {
  append_to_config_file "# xerces-${VERSION_xerces}: ${DESC_xerces}"
  append_to_config_file "export VERSION_xerces=${VERSION_xerces}"
  append_to_config_file "export LINK_libxerces_c=${LINK_libxerces_c}"
}