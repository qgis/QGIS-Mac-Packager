#!/bin/bash

DESC_uriparser="uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C89"


LINK_liburiparser=liburiparser.1.dylib

DEPS_uriparser=()


# md5 of the package

# default build path
BUILD_uriparser=${DEPS_BUILD_PATH}/uriparser/$(get_directory $URL_uriparser)

# default recipe path
RECIPE_uriparser=$RECIPES_PATH/uriparser

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_uriparser() {
  cd $BUILD_uriparser


}

function shouldbuild_uriparser() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_liburiparser} -nt $BUILD_uriparser/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_uriparser() {
  verify_binary lib/${LINK_liburiparser}
}

# function to append information to config file
function add_config_info_uriparser() {
  append_to_config_file "# uriparser-${VERSION_uriparser}: ${DESC_uriparser}"
  append_to_config_file "export VERSION_uriparser=${VERSION_uriparser}"
  append_to_config_file "export LINK_liburiparser=${LINK_liburiparser}"
}