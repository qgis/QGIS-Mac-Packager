#!/bin/bash

DESC_grass="Geographic Resources Analysis Support System"

# version of your package
VERSION_grass_major=7.8
VERSION_grass=${VERSION_grass_major}.2


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

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_grass() {
  cd $BUILD_grass

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # it tries to install HELP to system
  try mkdir -p $BUILD_grass/Library/Documentation/Help
  try mkdir -p $BUILD_grass/Home/Library/Documentation/Help
  try ${SED} "s; /Library/Documentation/Help; $BUILD_grass/Library/Documentation/Help;g" include/Make/Install.make
  try ${SED} "s; $HOME/Library/Documentation/Help; $BUILD_grass/Home/Library/Documentation/Help;g" macosx/app/build_html_user_index.sh

  patch_configure_file configure

  touch .patched
}

function shouldbuild_grass() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/grass78/lib/libgrass_calc.dylib -nt $BUILD_grass/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_grass() {
  try rsync -a $BUILD_grass/ $BUILD_PATH/grass/build-$ARCH/
  try cd $BUILD_PATH/grass/build-$ARCH
  push_env

  # No DEBUG symbols!
  export CFLAGS="-O2"
  export CXXFLAGS="-O2"

  # when building with LIB=...
  # lib/gpde fails with undefined symbols to _G_calloc and others
  # see

  unset LDFLAGS
  unset LIB
  unset INCLUDE
  unset LIB_DIR

  try ${CONFIGURE} \
    --with-cxx \
    --enable-shared \
    --exec_prefix=$STAGE_PATH \
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
    --with-python=no \
    --with-macosx-archs=x86_64

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_grass() {
  verify_lib "../grass78/lib/libgrass_calc.dylib"
}

# function to append information to config file
function add_config_info_grass() {
  append_to_config_file "# grass-${VERSION_grass}: ${DESC_grass}"
  append_to_config_file "export VERSION_grass=${VERSION_grass}"
}