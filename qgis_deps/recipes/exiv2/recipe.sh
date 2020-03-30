#!/bin/bash

DESC_exiv2="EXIF and IPTC metadata manipulation library and tools"

# version of your package
VERSION_exiv2=0.27.2

# dependencies of this recipe
DEPS_exiv2=()

# url of the package
URL_exiv2=https://www.exiv2.org/builds/exiv2-${VERSION_exiv2}-Source.tar.gz

# md5 of the package
MD5_exiv2=8c39c39dc8141bb158e8e9d663bcbf21

# default build path
BUILD_exiv2=$BUILD_PATH/exiv2/$(get_directory $URL_exiv2)

# default recipe path
RECIPE_exiv2=$RECIPES_PATH/exiv2

patch_exiv2_linker_links () {
  targets=(
    bin/exifcomment
    bin/exifdata
    bin/exifprint
    bin/exifvalue
    bin/exiv2
    bin/exiv2json
    bin/xmpdump
    bin/xmpparse
    bin/xmpprint
    bin/xmpsample
    bin/iotest
    bin/addmoddel
    bin/geotag
    bin/mrwthumb
    bin/convert-test
    bin/easyaccess-test
    bin/exifdata-test
    bin/ini-test
    bin/iotest
    bin/iptctest
    bin/key-test
    bin/largeiptc-test
    bin/mmap-test
    bin/path-test
    bin/prevtest
    bin/stringto-test
    bin/tiff-test
    bin/werror-test
    bin/write-test
    bin/write2-test
    bin/xmpparser-test
    bin/taglist
    bin/iptceasy
    bin/iptcprint
    bin/metacopy
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/exiv2/build-$ARCH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_exiv2() {
  cd $BUILD_exiv2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_exiv2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libexiv2.dylib -nt $BUILD_exiv2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_exiv2() {
  try mkdir -p $BUILD_PATH/exiv2/build-$ARCH
  try cd $BUILD_PATH/exiv2/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_exiv2
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  patch_exiv2_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_exiv2() {
  verify_lib "libexiv2.dylib"

  verify_bin addmoddel
}
