#!/bin/bash

DESC_python_pillow="python pillow"

# version of your package
VERSION_python_pillow=7.2.0

# dependencies of this recipe
DEPS_python_pillow=(python python_packages_pre zlib jpeg libtiff webp little_cms2 python_numpy)

# url of the package
URL_python_pillow=https://github.com/python-pillow/Pillow/archive/${VERSION_python_pillow}.tar.gz

# md5 of the package
MD5_python_pillow=756a9a00895f1b40e297110b8abc6895

# default build path
BUILD_python_pillow=$BUILD_PATH/python_pillow/$(get_directory $URL_python_pillow)

# default recipe path
RECIPE_python_pillow=$RECIPES_PATH/python_pillow

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pillow() {
  cd $BUILD_python_pillow

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_pillow() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed PIL; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_pillow() {
  try rsync -a $BUILD_python_pillow/ $BUILD_PATH/python_pillow/build-$ARCH/
  try cd $BUILD_PATH/python_pillow/build-$ARCH
  push_env

  # unfortunately they named the file Zip.h, clashing with the lzip library
  # see https://github.com/python-pillow/Pillow/pull/4812
  try mv src/libImaging/Zip.h src/libImaging/Zip2.h
  try ${SED} "s;Zip.h;Zip2.h;g" src/libImaging/ZipDecode.c
  try ${SED} "s;Zip.h;Zip2.h;g" src/libImaging/ZipEncode.c
  try ${SED} "s;Zip.h;Zip2.h;g" src/Pillow.egg-info/SOURCES.txt
  try ${SED} "s;Zip.h;Zip2.h;g" src/decode.c
  try ${SED} "s;Zip.h;Zip2.h;g" src/encode.c

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}

# function called after all the compile have been done
function postbuild_python_pillow() {
   if ! python_package_installed PIL; then
      error "Missing python package PIL"
   fi
}

# function to append information to config file
function add_config_info_python_pillow() {
  append_to_config_file "# python_pillow-${VERSION_python_pillow}: ${DESC_python_pillow}"
  append_to_config_file "export VERSION_python_pillow=${VERSION_python_pillow}"
}