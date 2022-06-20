#!/bin/bash

DESC_grass="Geographic Resources Analysis Support System"


DEPS_grass=(python boost bison flex libtiff png  sqlite geos zlib wxmac zstd zlib xz netcdf proj gdal libgeotiff python_pyqt5 mysql postgres openssl )

LINK_libgrass_version=26

# default build path
BUILD_grass=${DEPS_BUILD_PATH}/grass/$(get_directory $URL_grass)

# default recipe path
RECIPE_grass=$RECIPES_PATH/grass

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_grass() {
  cd $BUILD_grass

  # Usage of cc instead of clang
  patch_configure_file configure

  # Usage of /usr/local
  try ${SED} "s;/usr/local/lib' ;$STAGE_PATH/lib', '$STAGE_PATH/grass${VERSION_grass_major}${VERSION_grass_minor}/lib ;g" lib/python/ctypes/loader.py

  # it tries to install HELP to system
  # see https://github.com/OSGeo/grass/issues/474
  try mkdir -p $BUILD_grass/Library/Documentation/Help
  try mkdir -p $BUILD_grass/Home/Library/Documentation/Help
  try ${SED} "s; /Library/Documentation/Help; $BUILD_grass/Library/Documentation/Help;g" include/Make/Install.make
  try ${SED} "s; \$HOME/Library/Documentation/Help; $BUILD_grass/Home/Library/Documentation/Help;g" macosx/app/build_html_user_index.sh

  # missing space in gpde Makefile
  try ${SED} "s;EXTRA_LIBS=\$(GISLIB);EXTRA_LIBS = \$(GISLIB);g" lib/gpde/Makefile

  try rsync -a $BUILD_grass/ ${DEPS_BUILD_PATH}/grass/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_grass() {
  verify_binary grass${VERSION_grass_major}${VERSION_grass_minor}/lib/libgrass_calc.dylib
}

# function to append information to config file
function add_config_info_grass() {
  append_to_config_file "# grass-${VERSION_grass}: ${DESC_grass}"
  append_to_config_file "export VERSION_grass_major=${VERSION_grass_major}"
  append_to_config_file "export VERSION_grass_minor=${VERSION_grass_minor}"
  append_to_config_file "export VERSION_grass=${VERSION_grass}"
  append_to_config_file "export VERSION_grass_build=${VERSION_grass_build}"
}