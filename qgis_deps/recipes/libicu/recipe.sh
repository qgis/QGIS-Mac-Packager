#!/bin/bash

DESC_libicu="International Components for Unicode"

# version of your package
VERSION_libicu_major=68
VERSION_libicu_minor=2
VERSION_libicu=$VERSION_libicu_major.$VERSION_libicu_minor

LINK_libicudata=libicudata.${VERSION_libicu_major}.dylib
LINK_libicuuc=libicuuc.$VERSION_libicu_major.dylib
LINK_libicui18n=libicui18n.$VERSION_libicu_major.dylib
LINK_libicuio=libicuio.$VERSION_libicu_major.dylib
LINK_libicutu=libicutu.$VERSION_libicu_major.dylib

# dependencies of this recipe
DEPS_libicu=(python)

# url of the package
URL_libicu=https://github.com/unicode-org/icu/archive/release-$VERSION_libicu_major-$VERSION_libicu_minor.tar.gz

# md5 of the package
MD5_libicu=ea591dfbcbc3aa44029ca66d6abf8070

# default build path
BUILD_libicu=$BUILD_PATH/libicu/$(get_directory $URL_libicu)

# default recipe path
RECIPE_libicu=$RECIPES_PATH/libicu

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libicu() {
  cd $BUILD_libicu/icu4c/source

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libicu() {
  if [ ${STAGE_PATH}/lib/${LINK_libicudata} -nt $BUILD_libicu/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libicu() {
  try rsync -a $BUILD_libicu/ $BUILD_PATH/libicu/build-$ARCH/
  try cd $BUILD_PATH/libicu/build-$ARCH/icu4c/source
  push_env

  try ${CONFIGURE} \
    --disable-samples \
    --disable-extras \
    --disable-layout \
    --disable-tests \

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  targets=(
    libicudata.$VERSION_libicu_major.dylib
    libicui18n.$VERSION_libicu_major.dylib
    libicuio.$VERSION_libicu_major.dylib
    libicutu.$VERSION_libicu_major.dylib
    libicuuc.$VERSION_libicu_major.dylib
  )
  for i in ${targets[*]}
  do
    try install_name_tool -id $STAGE_PATH/lib/$i $STAGE_PATH/lib/$i
    for j in ${targets[*]}
    do
      try install_name_tool -change $j $STAGE_PATH/lib/$j $STAGE_PATH/lib/$i
    done
  done

  pop_env
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