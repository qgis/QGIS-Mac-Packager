#!/bin/bash

function check_exiv2() {
  env_var_exists VERSION_exiv2
}

function bundle_exiv2() {
    :
}

function postbundle_exiv2() {
    :
}

function add_config_info_exiv2() {
    :
}

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
