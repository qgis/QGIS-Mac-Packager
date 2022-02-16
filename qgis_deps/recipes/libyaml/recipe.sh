#!/bin/bash

DESC_libyaml="YAML parser"

# version of your package
VERSION_libyaml=0.2.5

LINK_libyaml=libyaml-0.2.dylib

# dependencies of this recipe
DEPS_libyaml=()

# url of the package
URL_libyaml=https://github.com/yaml/libyaml/archive/${VERSION_libyaml}.tar.gz

# md5 of the package
MD5_libyaml=163fc1e22153d3e2cebfe5cbb43a1769

# default build path
BUILD_libyaml=$BUILD_PATH/libyaml/$(get_directory $URL_libyaml)

# default recipe path
RECIPE_libyaml=$RECIPES_PATH/libyaml

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libyaml() {
  cd $BUILD_libyaml
  try rsync -a $BUILD_libyaml/ ${BUILD_PATH}/libyaml/build-${ARCH}
}

function shouldbuild_libyaml() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libyaml -nt $BUILD_libyaml/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libyaml() {
  verify_binary lib/$LINK_libyaml
}

# function to append information to config file
function add_config_info_libyaml() {
  append_to_config_file "# libyaml-${VERSION_libyaml}: ${DESC_libyaml}"
  append_to_config_file "export VERSION_libyaml=${VERSION_libyaml}"
  append_to_config_file "export LINK_libyaml=${LINK_libyaml}"
}
