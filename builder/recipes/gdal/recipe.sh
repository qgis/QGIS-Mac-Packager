#!/bin/bash

# version of your package
VERSION_gdal=3.0.4

# dependencies of this recipe
DEPS_gdal=(geos proj libgeotiff libxml2 xerces xz zstd libtiff netcdf hdf5 postgres jpeg png)

LINK_libgdal_version=26

# url of the package
URL_gdal=https://github.com/OSGeo/gdal/releases/download/v${VERSION_gdal}/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=c6bbb5caca06e96bd97a32918e0aa9aa

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

patch_gdal_linker_links () {
  install_name_tool -id "@rpath/libgdal.dylib" ${STAGE_PATH}/lib/libgdal.dylib

  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libgdal.${LINK_libgdal_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgdal.${LINK_libgdal_version}.dylib does not exist... maybe you updated the gdal version?"
  fi

  targets=(
    bin/nearblack
    bin/gdal-config
    bin/gdal_contour
    bin/gdal_grid
    bin/gdal_rasterize
    bin/gdal_translate
    bin/gdaladdo
    bin/gdalbuildvrt
    bin/gdaldem
    bin/gdalenhance
    bin/gdalinfo
    bin/gdallocationinfo
    bin/gdalmanage
    bin/gdalserver
    bin/gdalsrsinfo
    bin/gdaltindex
    bin/gdaltransform
    bin/gdalwarp
    bin/ogr2ogr
    bin/ogrinfo
    bin/ogrlineref
    bin/ogrtindex
    bin/testepsg
    bin/gnmanalyse
    bin/gnmmanage
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libgdal.${LINK_libgdal_version}.dylib" "@rpath/libgdal.${LINK_libgdal_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  patch_gdal_linker_links

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
  for i in xerces liblzma zstd libtiff geotiff jpeg hdf5 netcdf pg png
  do
    WITH_GDAL_DRIVERS="$WITH_GDAL_DRIVERS --with-$i=$STAGE_DIR"
  done

  WITHOUT_GDAL_DRIVERS=
  for i in ecw grass libgrass cfitsio pcraster \
           dds gta gif ogdi fme sosi mongocxx \
           mongocxxv3 hdf4 kea jasper openjpeg fgdb \
           kakadu mrsid jp2mrsid mrsid_lidar \
           msg oci mysql ingres expat libkml odbc \
           dods-root spatialite sqlite3 rasterlite2
  do
    WITHOUT_GDAL_DRIVERS="$WITHOUT_GDAL_DRIVERS --without-$i"
  done

  try ${CONFIGURE} \
    --disable-debug \
    ${WITH_GDAL_DRIVERS} \
    ${WITHOUT_GDAL_DRIVERS}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  patch_gdal_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
  verify_lib "libgdal.dylib"
  verify_bin gdalmanage
}
