#!/bin/bash

DESC_grass="Geographic Resources Analysis Support System"

# version of your package
VERSION_grass=7.8.2

# dependencies of this recipe
DEPS_grass=(python boost bison flex libtiff png  sqlite geos zlib wxmac zstd zlib xz netcdf proj gdal libgeotiff python_pyqt5 mysql postgres openssl )

LINK_libgrass_version=26

# url of the package
URL_grass=https://github.com/OSGeo/grass/archive/${VERSION_grass}.tar.gz

# md5 of the package
MD5_grass=276506d7df11a341ab03c64da6acaee2

# default build path
BUILD_grass=$BUILD_PATH/grass/$(get_directory $URL_grass)

# default recipe path
RECIPE_grass=$RECIPES_PATH/grass

patch_grass_linker_links () {
  install_name_tool -id "@rpath/libgrass.dylib" ${STAGE_PATH}/lib/libgrass.dylib

  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libgrass.${LINK_libgrass_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgrass.${LINK_libgrass_version}.dylib does not exist... maybe you updated the grass version?"
  fi

  targets=(
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libgrass.${LINK_libgrass_version}.dylib" "@rpath/libgrass.${LINK_libgrass_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_grass() {
  cd $BUILD_grass

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_grass() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libgrass.dylib -nt $BUILD_grass/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_grass() {
  try rsync -a $BUILD_grass/ $BUILD_PATH/grass/build-$ARCH/
  try cd $BUILD_PATH/grass/build-$ARCH
  push_env

#--with-readline \
#--with-readline-includes=#{Formula["readline"]include \
#--with-readline-libs=#{Formula["readline"/lib \
#--with-blas \
#--with-blas-includes=#{Formula["openblas"]include \
#--with-blas-libs=#{Formula["openblas"/lib \
#--with-lapack \
#--with-lapack-includes=#{Formula["lapack"]include \
#--with-lapack-libs=#{Formula["lapack"/lib \
#    --with-odbc \
#    --with-odbc-includes=#{Formula["unixodbc"]include \
#    --with-odbc-libs=#{Formula["unixodbc"/lib \
#     --with-bzlib \
#    --with-bzlib-includes=#{Formula["bzip2"]include \
#    --with-bzlib-libs=#{Formula["bzip2"/lib \
#     --with-cairo \
#    --with-cairo-includes=#{Formula["cairo"]include/cairo \
#    --with-cairo-libs=#{Formula["cairo"/lib \
#    --with-cairo-ldflags=-lfontconfig \
#    --with-freetype \
#    --with-freetype-includes=#{Formula["freetype"]include/freetype2 \
#    --with-freetype-libs=#{Formula["freetype"/lib \
#          # "--with-proj \
#    --with-regex \
#          # "--with-regex-includes=#{Formula["regex-opt"/lib \
#          # "--with-regex-libs=#{Formula["regex-opt"/lib \
#     --with-fftw \
#    --with-fftw-includes=#{Formula["fftw"]include \
#    --with-fftw-libs=#{Formula["fftw"/lib \

  try ${CONFIGURE} \
    --with-cxx \
    --enable-shared \
    --with-includes=$STAGE_PATH/include \
    --with-libs=$STAGE_PATH/lib \
    --without-tcltk \
    --with-netcdf=$STAGE_PATH/bin/nc-config \
    --with-zstd \
    --with-zstd-includes=$STAGE_PATH/include \
    --with-zstd-libs=$STAGE_PATH/lib \
    --with-geos=$STAGE_PATH/bin/geos-config \
    --with-geos-includes=$STAGE_PATH/include \
    --with-geos-libs=$STAGE_PATH/lib \
    --with-gdal=$STAGE_PATH/bin/gdal-config \
    --with-zlib-includes=$STAGE_PATH/include \
    --with-zlib-libs=$STAGE_PATH/lib \
    --with-proj-includes=$STAGE_PATH/include \
    --with-proj-libs=$STAGE_PATH/lib \
    --with-proj-share=$STAGE_PATH/share/proj \
    --with-tiff \
    --with-tiff-includes=$STAGE_PATH/include \
    --with-tiff-libs=$STAGE_PATH/lib \
    --with-png \
    --with-png-includes=$STAGE_PATH/include \
    --with-png-libs=$STAGE_PATH/lib \
    --with-sqlite \
    --with-sqlite-includes=$STAGE_PATH/include \
    --with-sqlite-libs=$STAGE_PATH/lib \
    --without-fftw \
    --without-postgres \
    --without-mysql \
    --with-pthread \
    --with-pthread-includes=$STAGE_PATH/include/boost/thread \
    --with-pthread-libs=$STAGE_PATH/lib \
    --without-pdal \
    --without-opendwg \
    --without-opencl \
    --without-opengl \
    --without-motif \
    --without-glw \
    --without-wxwidgets \
    --without-cairo \
    --without-freetype \
    --enable-64bit \
    --with-macosx-sdk=`xcrun --show-sdk-path`

    # --with-opengl-includes=#{MacOS.sdk_path}/System/Library/Frameworks/OpenGL.framework/Headers


  check_file_configuration config.status

  try $MAKESMP GDAL_DYNAMIC=
  try $MAKE GDAL_DYNAMIC= install

  patch_grass_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_grass() {
  verify_lib "libgrass.dylib"
  verify_bin grassmanage
}

# function to append information to config file
function add_config_info_grass() {
  append_to_config_file "# grass-${VERSION_grass}: ${DESC_grass}"
  append_to_config_file "export VERSION_grass=${VERSION_grass}"
}