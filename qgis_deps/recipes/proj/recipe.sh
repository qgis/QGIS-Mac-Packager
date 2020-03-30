#!/bin/bash

DESC_proj="Cartographic Projections Library"

# version of your package
VERSION_proj=6.3.1

# dependencies of this recipe
DEPS_proj=()

# url of the package
URL_proj=https://github.com/OSGeo/PROJ/releases/download/$VERSION_proj/proj-$VERSION_proj.tar.gz

# md5 of the package
MD5_proj=c44c694cf569a74880e5fbac566d54d6

# default build path
BUILD_proj=$BUILD_PATH/proj/$(get_directory $URL_proj)

# default recipe path
RECIPE_proj=$RECIPES_PATH/proj

patch_proj_linker_links () {
  targets=(
    bin/proj
    bin/gie
    bin/geod
    bin/projinfo
    bin/cct
    bin/cs2cs
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/proj/build-$ARCH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj() {
  cd $BUILD_proj

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_proj() {
  if [ ${STAGE_PATH}/lib/libproj.dylib -nt $BUILD_proj/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_proj() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  try $CMAKE $BUILD_proj .
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKE install

  patch_proj_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_proj() {
  verify_lib "libproj.dylib"

  verify_bin proj
}
