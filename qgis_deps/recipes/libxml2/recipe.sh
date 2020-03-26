#!/bin/bash

# version of your package
VERSION_libxml2=2.9.10

LINK_libxml2_version=2

# dependencies of this recipe
DEPS_libxml2=()

# url of the package
URL_libxml2=http://xmlsoft.org/sources/libxml2-${VERSION_libxml2}.tar.gz

# md5 of the package
MD5_libxml2=10942a1dc23137a8aa07f0639cbfece5

# default build path
BUILD_libxml2=$BUILD_PATH/libxml2/$(get_directory $URL_libxml2)

# default recipe path
RECIPE_libxml2=$RECIPES_PATH/libxml2

patch_libxml2_linker_links () {
  install_name_tool -id "@rpath/libxml2.dylib" ${STAGE_PATH}/lib/libxml2.dylib

  targets=(
    bin/xml2-config
    bin/xmlcatalog
    bin/xmllint
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libxml2.${LINK_libxml2_version}.dylib" "@rpath/libxml2.${LINK_libwebp_version}.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libxml2() {
  cd $BUILD_libxml2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libxml2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libxml2.dylib -nt $BUILD_libxml2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libxml2() {
  try rsync -a $BUILD_libxml2/ $BUILD_PATH/libxml2/build-$ARCH/
  try cd $BUILD_PATH/libxml2/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --without-lzma \
    --without-python \
    --with-history

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  if [ ! -e $STAGE_PATH/include/libxml ]; then
    try ln -s "$STAGE_PATH/include/libxml2/libxml/" "$STAGE_PATH/include/libxml"
  fi

  patch_libxml2_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_libxml2() {
  verify_lib "libxml2.dylib"
}
