#!/bin/bash

DESC_proj="Cartographic Projections Library"

# version of your package
# keep in SYNC with python_pyproj receipt
VERSION_proj=9.2.0

LINK_libproj=libproj.25.dylib

# dependencies of this recipe
DEPS_proj=(sqlite libxml2 openssl libtiff)

# url of the package
URL_proj=https://github.com/OSGeo/PROJ/releases/download/$VERSION_proj/proj-$VERSION_proj.tar.gz

# md5 of the package
MD5_proj=1241c7115d8c380ea19469ba0828a22a

# default build path
BUILD_proj=$BUILD_PATH/proj/$(get_directory $URL_proj)

# default recipe path
RECIPE_proj=$RECIPES_PATH/proj

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
  if [ ${STAGE_PATH}/lib/${LINK_libproj} -nt $BUILD_proj/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_proj() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  try $CMAKE \
    -DPROJ_CMAKE_SUBDIR=share/cmake/proj4 \
    -DPROJ_DATA_SUBDIR=share/proj \
    -DPROJ_INCLUDE_SUBDIR=include \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=ON \
  $BUILD_proj .

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libproj $STAGE_PATH/lib/$LINK_libproj
  try install_name_tool -change $BUILD_PATH/proj/build-$ARCH/lib/$LINK_libproj $STAGE_PATH/lib/$LINK_libproj $STAGE_PATH/bin/proj
  try install_name_tool -delete_rpath $BUILD_PATH/proj/build-$ARCH/lib ${STAGE_PATH}/lib/$LINK_libproj

  try fix_install_name bin/cct
  try fix_install_name bin/cs2cs
  try fix_install_name bin/geod
  try fix_install_name bin/gie
  try fix_install_name bin/invgeod
  try fix_install_name bin/projinfo
  try fix_install_name bin/projsync

  pop_env
}

# function called after all the compile have been done
function postbuild_proj() {
  verify_binary lib/$LINK_libproj

  verify_binary bin/proj
  verify_binary bin/cct
  verify_binary bin/cs2cs
  verify_binary bin/geod
  verify_binary bin/gie
  verify_binary bin/invgeod
  verify_binary bin/projinfo
  verify_binary bin/projsync
}

# function to append information to config file
function add_config_info_proj() {
  append_to_config_file "# proj-${VERSION_proj}: ${DESC_proj}"
  append_to_config_file "export VERSION_proj=${VERSION_proj}"
  append_to_config_file "export LINK_libproj=${LINK_libproj}"
}