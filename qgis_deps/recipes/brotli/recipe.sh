#!/bin/bash

DESC_brotli="Generic-purpose lossless compression algorithm by Google"


LINK_libbrotlicommon=libbrotlicommon.${VERSION_brotli_major}.dylib
LINK_libbrotlidec=libbrotlidec.${VERSION_brotli_major}.dylib

DEPS_brotli=()


# md5 of the package

# default build path
BUILD_brotli=${DEPS_BUILD_PATH}/brotli/$(get_directory $URL_brotli)

# default recipe path
RECIPE_brotli=$RECIPES_PATH/brotli

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_brotli() {
  cd $BUILD_brotli


}

function shouldbuild_brotli() {
  if [ ${STAGE_PATH}/lib/${LINK_libbrotlidec} -nt $BUILD_brotli/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_brotli() {
  verify_binary lib/$LINK_libbrotlicommon
  verify_binary lib/$LINK_libbrotlidec
}

# function to append information to config file
function add_config_info_brotli() {
  append_to_config_file "# brotli-${VERSION_brotli}: ${DESC_brotli}"
  append_to_config_file "export VERSION_brotli=${VERSION_brotli}"
  append_to_config_file "export LINK_libbrotlicommon=${LINK_libbrotlicommon}"
  append_to_config_file "export LINK_libbrotlidec=${LINK_libbrotlidec}"
}