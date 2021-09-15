#!/bin/bash

DESC_proj="Cartographic Projections Library"

# version of your package
# keep in SYNC with python_pyproj receipt
VERSION_proj=8.1.1

LINK_libproj=libproj.22.dylib

# dependencies of this recipe
DEPS_proj=(sqlite libxml2 openssl libtiff)

# url of the package
URL_proj=https://github.com/OSGeo/PROJ/releases/download/$VERSION_proj/proj-$VERSION_proj.tar.gz

# md5 of the package
MD5_proj=f017fd7d35311b0d65b2cf0503844690

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

  pop_env
}

# function called after all the compile have been done
function postbuild_proj() {
  verify_binary lib/$LINK_libproj

  verify_binary bin/proj
}

# function to append information to config file
function add_config_info_proj() {
  append_to_config_file "# proj-${VERSION_proj}: ${DESC_proj}"
  append_to_config_file "export VERSION_proj=${VERSION_proj}"
  append_to_config_file "export LINK_libproj=${LINK_libproj}"
}