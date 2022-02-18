#!/bin/bash

DESC_xerces="Validating XML parser written in a portable subset of C++"

# version of your package
VERSION_xerces=3.2.3

LINK_libxerces_c=libxerces-c-3.2.dylib
# dependencies of this recipe
DEPS_xerces=(expat libcurl libicu)

# url of the package
URL_xerces=https://dlcdn.apache.org//xerces/c/3/sources/xerces-c-${VERSION_xerces}.tar.gz

# md5 of the package
MD5_xerces=a5fa4d920fce31c9ca3bfef241644494

# default build path
BUILD_xerces=${DEPS_BUILD_PATH}/xerces/$(get_directory $URL_xerces)

# default recipe path
RECIPE_xerces=$RECIPES_PATH/xerces

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xerces() {
  cd $BUILD_xerces


}

function shouldbuild_xerces() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libxerces_c} -nt $BUILD_xerces/.patched ]; then
    DO_BUILD=0
  fi
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