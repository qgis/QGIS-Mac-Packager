#!/bin/bash

DESC_libicu="International Components for Unicode"


VERSION_libicu_major=${VERSION_libicu//\.d+/}

LINK_libicudata=libicudata.${VERSION_libicu}.dylib
LINK_libicuuc=libicuuc.${VERSION_libicu}.dylib
LINK_libicui18n=libicui18n.${VERSION_libicu}.dylib
LINK_libicuio=libicuio.${VERSION_libicu}.dylib
LINK_libicutu=libicutu.${VERSION_libicu}.dylib

DEPS_libicu=(python)



# md5 of the package

# default build path
BUILD_libicu=${DEPS_BUILD_PATH}/libicu/$(get_directory $URL_libicu)

# default recipe path
RECIPE_libicu=$RECIPES_PATH/libicu

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libicu() {
  cd $BUILD_libicu/icu4c/source
    patch_configure_file configure
  try rsync  -a $BUILD_libicu/ ${DEPS_BUILD_PATH}/libicu/build-${ARCH}

}

function shouldbuild_libicu() {
  if [ ${STAGE_PATH}/lib/${LINK_libicudata} -nt $BUILD_libicu/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libicu() {
  verify_binary lib/$LINK_libicudata
  verify_binary lib/$LINK_libicuuc
}

# function to append information to config file
function add_config_info_libicu() {
  append_to_config_file "# libicu-${VERSION_libicu}: ${DESC_libicu}"
  append_to_config_file "export VERSION_libicu=${VERSION_libicu}"
  append_to_config_file "export LINK_libicudata=${LINK_libicudata}"
  append_to_config_file "export LINK_libicuuc=${LINK_libicuuc}"
  append_to_config_file "export LINK_libicui18n=${LINK_libicui18n}"
  append_to_config_file "export LINK_libicuio=${LINK_libicuio}"
  append_to_config_file "export LINK_libicutu=${LINK_libicutu}"
}