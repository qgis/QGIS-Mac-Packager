#!/bin/bash

DESC_libkml="This is Google's reference implementation of OGC KML 2.2"

# version of your package
VERSION_libkml=1.3.0
LINK_libkmlbase=libkmlbase.1.dylib
LINK_libkmlconvenience=libkmlconvenience.1.dylib
LINK_libkmldom=libkmldom.1.dylib
LINK_libkmlengine=libkmlengine.1.dylib
LINK_libkmlregionator=libkmlregionator.1.dylib
LINK_libkmlxsd=libkmlxsd.1.dylib

# dependencies of this recipe
DEPS_libkml=(
  boost
  expat
  zlib
  minizip
  uriparser
)

# url of the package
URL_libkml=https://github.com/libkml/libkml/archive/refs/tags/${VERSION_libkml}.tar.gz

# md5 of the package
MD5_libkml=e663141e9ebd480538b25d226e1b2979

# default build path
BUILD_libkml=${DEPS_BUILD_PATH}/libkml/$(get_directory $URL_libkml)

# default recipe path
RECIPE_libkml=$RECIPES_PATH/libkml

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libkml() {
  cd $BUILD_libkml


}

function shouldbuild_libkml() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libkmlbase} -nt $BUILD_libkml/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libkml() {
  verify_binary lib/${LINK_libkmlbase}
  verify_binary lib/$LINK_libkmlconvenience
  verify_binary lib/$LINK_libkmldom
  verify_binary lib/$LINK_libkmlengine
  verify_binary lib/$LINK_libkmlregionator
  verify_binary lib/$LINK_libkmlxsd
}

# function to append information to config file
function add_config_info_libkml() {
  append_to_config_file "# libkml-${VERSION_libkml}: ${DESC_libkml}"
  append_to_config_file "export VERSION_libkml=${VERSION_libkml}"
  append_to_config_file "export LINK_libkmlbase=${LINK_libkmlbase}"
  append_to_config_file "export LINK_libkmlconvenience=${LINK_libkmlconvenience}"
  append_to_config_file "export LINK_libkmldom=${LINK_libkmldom}"
  append_to_config_file "export LINK_libkmlengine=${LINK_libkmlengine}"
  append_to_config_file "export LINK_libkmlregionator=${LINK_libkmlregionator}"
  append_to_config_file "export LINK_libkmlxsd=${LINK_libkmlxsd}"
}