#!/bin/bash

# version of your package
VERSION_gdal=3.0.4

# dependencies of this recipe
DEPS_gdal=(geos proj libgeotiff xerces)

# url of the package
URL_gdal=https://github.com/OSGeo/gdal/releases/download/v${VERSION_gdal}/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=c6bbb5caca06e96bd97a32918e0aa9aa

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libgdal.dylib -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH
  push_env


  WITH_GDAL_DRIVERS=
  for i in xerces
  do
    WITH_GDAL_DRIVERS="$WITH_GDAL_DRIVERS --with-$i=$STAGE_DIR"
  done

  WITHOUT_GDAL_DRIVERS=
  for i in ecw
  do
    WITHOUT_GDAL_DRIVERS="$WITHOUT_GDAL_DRIVERS --without-$i"
  done

  try ${BUILD_gdal}/${CONFIGURE} \
    --disable-debug \
    ${WITH_GDAL_DRIVERS} \
    ${WITHOUT_GDAL_DRIVERS}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
  verify_lib "${STAGE_PATH}/lib/libgdal.dylib"
}
