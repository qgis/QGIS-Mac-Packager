#!/bin/bash

DESC_libkml="This is Google's reference implementation of OGC KML 2.2"

LINK_libkmlbase=libkmlbase.1.dylib
LINK_libkmlconvenience=libkmlconvenience.1.dylib
LINK_libkmldom=libkmldom.1.dylib
LINK_libkmlengine=libkmlengine.1.dylib
LINK_libkmlregionator=libkmlregionator.1.dylib
LINK_libkmlxsd=libkmlxsd.1.dylib

DEPS_libkml=(
  boost
  expat
  zlib
  minizip
  uriparser
)


# md5 of the package

# default build path
BUILD_libkml=${DEPS_BUILD_PATH}/libkml/$(get_directory $URL_libkml)

# default recipe path
RECIPE_libkml=$RECIPES_PATH/libkml

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libkml() {
  cd $BUILD_libkml
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