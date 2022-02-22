#!/bin/bash

DESC_poppler="PDF rendering library (based on the xpdf-3.0 code base)"


LINK_poppler=libpoppler.118.dylib
LINK_poppler_cpp=libpoppler-cpp.0.dylib
LINK_poppler_qt5=libpoppler-qt5.1.dylib

DEPS_poppler=(
  poppler_data
  fontconfig
  freetype
  gettext
  jpeg
  png
  libtiff
  little_cms2
  openjpeg
  libcurl
)


# md5 of the package

# default build path
BUILD_poppler=${DEPS_BUILD_PATH}/poppler/$(get_directory $URL_poppler)

# default recipe path
RECIPE_poppler=$RECIPES_PATH/poppler

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_poppler() {
  cd $BUILD_poppler


}

function shouldbuild_poppler() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_poppler} -nt $BUILD_poppler/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_poppler() {
  verify_binary lib/${LINK_poppler}
  verify_binary lib/${LINK_poppler_cpp}
  verify_binary lib/${LINK_poppler_qt5}
}

# function to append information to config file
function add_config_info_poppler() {
  append_to_config_file "# poppler-${VERSION_poppler}: ${DESC_poppler}"
  append_to_config_file "export VERSION_poppler=${VERSION_poppler}"
  append_to_config_file "export LINK_poppler=${LINK_poppler}"
  append_to_config_file "export LINK_poppler_cpp=${LINK_poppler_cpp}"
  append_to_config_file "export LINK_poppler_qt5=${LINK_poppler_qt5}"
}