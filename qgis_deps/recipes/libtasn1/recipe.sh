#!/bin/bash

DESC_libtasn1="ASN.1 structure parser library"


LINK_libtasn1=libtasn1.6.dylib

DEPS_libtasn1=(gettext)


# md5 of the package

# default build path
BUILD_libtasn1=${DEPS_BUILD_PATH}/libtasn1/$(get_directory $URL_libtasn1)

# default recipe path
RECIPE_libtasn1=$RECIPES_PATH/libtasn1

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtasn1() {
  cd $BUILD_libtasn1
  try rsync -a $BUILD_libtasn1/ ${DEPS_BUILD_PATH}/libtasn1/build-${ARCH}


}

function shouldbuild_libtasn1() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libtasn1 -nt $BUILD_libtasn1/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libtasn1() {
  verify_binary lib/$LINK_libtasn1
}

# function to append information to config file
function add_config_info_libtasn1() {
  append_to_config_file "# libtasn1-${VERSION_libtasn1}: ${DESC_libtasn1}"
  append_to_config_file "export VERSION_libtasn1=${VERSION_libtasn1}"
  append_to_config_file "export LINK_libtasn1=${LINK_libtasn1}"
}