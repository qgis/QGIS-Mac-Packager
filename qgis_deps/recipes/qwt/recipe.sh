#!/bin/bash

DESC_qwt="Qt Widgets for Technical Applications"


VERSION_qwt_major=$(echo ${VERSION_qwt} | gsed -r 's/([0-9]+)\..*$/\1/')

DEPS_qwt=()

# default build path
BUILD_qwt=${DEPS_BUILD_PATH}/qwt/$(get_directory $URL_qwt)

# default recipe path
RECIPE_qwt=$RECIPES_PATH/qwt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qwt() {
  cd $BUILD_qwt

  # Install in stage path
  try ${SED} "s;QWT_INSTALL_PREFIX.*=.*;QWT_INSTALL_PREFIX=$STAGE_PATH;g" qwtconfig.pri

  # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`
  try ${SED} "s;= \$\${QWT_INSTALL_PREFIX}/plugins/designer;=$STAGE_PATH/lib/qt/plugins/designer;g" qwtconfig.pri

  try rsync -a $BUILD_qwt/ ${DEPS_BUILD_PATH}/qwt/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_qwt() {
  verify_binary "lib/qt/plugins/designer/libqwt_designer_plugin.dylib"
  verify_binary "lib/qwt.framework/qwt"
}

# function to append information to config file
function add_config_info_qwt() {
  append_to_config_file "# qwt-${VERSION_qwt}: ${DESC_qwt}"
  append_to_config_file "export VERSION_qwt=${VERSION_qwt}"
  append_to_config_file "export VERSION_qwt_major=${VERSION_qwt_major}"
}