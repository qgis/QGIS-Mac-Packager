#!/bin/bash

DESC_little_cms2="Color management engine supporting ICC profiles"

LINK_little_cms2=liblcms2.2.dylib

DEPS_little_cms2=(jpeg libtiff)


# md5 of the package

# default build path
BUILD_little_cms2=${DEPS_BUILD_PATH}/little_cms2/$(get_directory $URL_little_cms2)

# default recipe path
RECIPE_little_cms2=$RECIPES_PATH/little_cms2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_little_cms2() {
  cd $BUILD_little_cms2
  try patch --verbose --forward -p1 < ${RECIPE_little_cms2}/patches/cms2.patch

  patch_configure_file configure
  try rsync -a $BUILD_little_cms2/ ${DEPS_BUILD_PATH}/little_cms2/build-${ARCH}
}

function shouldbuild_little_cms2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_little_cms2 -nt $BUILD_little_cms2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called after all the compile have been done
function postbuild_little_cms2() {
  verify_binary lib/$LINK_little_cms2
}

# function to append information to config file
function add_config_info_little_cms2() {
  append_to_config_file "# little_cms2-${VERSION_little_cms2}: ${DESC_little_cms2}"
  append_to_config_file "export VERSION_little_cms2=${VERSION_little_cms2}"
  append_to_config_file "export LINK_little_cms2=$LINK_little_cms2"
}
