#!/bin/bash

DESC_fastcgi="Protocol for interfacing interactive programs with a web server"

LINK_fastcgi=libfcgi.0.dylib

DEPS_fastcgi=()


# md5 of the package

# default build path
BUILD_fastcgi=${DEPS_BUILD_PATH}/fastcgi/$(get_directory $URL_fastcgi)

# default recipe path
RECIPE_fastcgi=$RECIPES_PATH/fastcgi

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_fastcgi() {
  cd $BUILD_fastcgi
  try rsync -a $BUILD_fastcgi/ ${DEPS_BUILD_PATH}/fastcgi/build-${ARCH}
}

function shouldbuild_fastcgi() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_fastcgi -nt $BUILD_fastcgi/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_fastcgi() {
  verify_binary lib/$LINK_fastcgi
}

# function to append information to config file
function add_config_info_fastcgi() {
  append_to_config_file "# fastcgi-${VERSION_fastcgi}: ${DESC_fastcgi}"
  append_to_config_file "export VERSION_fastcgi=${VERSION_fastcgi}"
  append_to_config_file "export LINK_fastcgi=${LINK_fastcgi}"
}
