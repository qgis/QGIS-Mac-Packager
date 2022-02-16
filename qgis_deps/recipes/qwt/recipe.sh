#!/bin/bash

DESC_qwt="Qt Widgets for Technical Applications"

# version of your package
VERSION_qwt_major=6
VERSION_qwt=$VERSION_qwt_major.1.6

# dependencies of this recipe
DEPS_qwt=()

# url of the package
URL_qwt=https://downloads.sourceforge.net/project/qwt/qwt/${VERSION_qwt}/qwt-${VERSION_qwt}.tar.bz2

# md5 of the package
MD5_qwt=cc71be5d6c33c2fc19ae8082ccdd3e83

# default build path
BUILD_qwt=$BUILD_PATH/qwt/$(get_directory $URL_qwt)

# default recipe path
RECIPE_qwt=$RECIPES_PATH/qwt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qwt() {
  cd $BUILD_qwt
  try rsync -a $BUILD_qwt/ ${BUILD_PATH}/qwt/build-${ARCH}


  # Install in stage path
  try ${SED} "s;QWT_INSTALL_PREFIX.*=.*;QWT_INSTALL_PREFIX=$STAGE_PATH;g" qwtconfig.pri

  # Install Qt plugin in `lib/qt/plugins/designer`, not `plugins/designer`
  try ${SED} "s;= \$\${QWT_INSTALL_PREFIX}/plugins/designer;=$STAGE_PATH/lib/qt/plugins/designer;g" qwtconfig.pri

}

function shouldbuild_qwt() {
  # If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/qt/plugins/designer/libqwt_designer_plugin.dylib" -nt $BUILD_qwt/.patched ]; then
    DO_BUILD=0
  fi
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