#!/bin/bash

# version of your package
VERSION_qca=2.3.0

# dependencies of this recipe
DEPS_qca=(openssl)

# url of the package
URL_qca=https://github.com/KDE/qca/archive/v${VERSION_qca}.tar.gz

# md5 of the package
MD5_qca=46bf9aef445129fa101dd68a3596a58f

# default build path
BUILD_qca=$BUILD_PATH/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

patch_qca_linker_links () {
  install_name_tool -id "@rpath/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5" ${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5

  targets=(
    bin/mozcerts-qt5
    bin/qcatool-qt5
  )

  for i in ${targets[*]}
  do
     install_name_tool -change "${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5" "@rpath/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5" ${STAGE_PATH}/$i
     install_name_tool -add_rpath $QT_BASE/clang_64/lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
  cd $BUILD_qca

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qca() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5 -nt $BUILD_qca/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qca() {
  try mkdir -p $BUILD_PATH/qca/build-$ARCH
  try cd $BUILD_PATH/qca/build-$ARCH
  push_env

  try ${CMAKE} \
    -DQCA_PLUGINS_INSTALL_DIR=$STAGE_PATH/qt5/plugins \
    -DQT4_BUILD=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_botan_PLUGIN=NO \
    -DWITH_gcrypt_PLUGIN=NO \
    -DWITH_gnupg_PLUGIN=NO \
    -DWITH_nss_PLUGIN=NO \
    -DWITH_pkcs11_PLUGIN=NO \
  $BUILD_qca

  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  patch_qca_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_qca() {
  verify_lib "qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5"
  verify_bin qcatool-qt5
}
