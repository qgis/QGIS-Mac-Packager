#!/bin/bash

DESC_exiv2="EXIF and IPTC metadata manipulation library and tools"

LINK_exiv2=libexiv2.27.dylib

DEPS_exiv2=()


# md5 of the package

# default build path
BUILD_exiv2=${DEPS_BUILD_PATH}/exiv2/$(get_directory $URL_exiv2)

# default recipe path
RECIPE_exiv2=$RECIPES_PATH/exiv2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_exiv2() {
  cd $BUILD_exiv2


}

function shouldbuild_exiv2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_exiv2 -nt $BUILD_exiv2/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_exiv2() {
  verify_binary lib/$LINK_exiv2
  verify_binary bin/addmoddel
}

# function to append information to config file
function add_config_info_exiv2() {
  append_to_config_file "# exiv2-${VERSION_exiv2}: ${DESC_exiv2}"
  append_to_config_file "export VERSION_exiv2=${VERSION_exiv2}"
  append_to_config_file "export LINK_exiv2=${LINK_exiv2}"
}