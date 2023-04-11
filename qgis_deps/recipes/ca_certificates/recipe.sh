#!/bin/bash

DESC_ca_certificates="Mozilla CA certificate store"

# version of your package
VERSION_ca_certificates="2023-01-10"

# dependencies of this recipe
DEPS_ca_certificates=()

# url of the package
URL_ca_certificates=https://curl.se/ca/cacert-${VERSION_ca_certificates}.pem

# md5 of the package
MD5_ca_certificates=e7cf471ba7c88f4e313f492a76e624b3

# default build path
BUILD_ca_certificates=$BUILD_PATH/ca_certificates

# default recipe path
RECIPE_ca_certificates=$RECIPES_PATH/ca_certificates

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_ca_certificates() {
  cd $BUILD_ca_certificates

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_ca_certificates() {
  if [ ${STAGE_PATH}/share/cacart.pem -nt $BUILD_ca_certificates/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_ca_certificates() {
  try mkdir -p $BUILD_PATH/ca_certificates/build-$ARCH
  try cd $BUILD_PATH/ca_certificates/build-$ARCH
  try cp $PACKAGES_PATH/ca_certificates/cacert-${VERSION_ca_certificates}.pem $BUILD_PATH/ca_certificates/build-$ARCH/cacert-${VERSION_ca_certificates}.pem

  push_env

  try cp $BUILD_PATH/ca_certificates/build-$ARCH/cacert-${VERSION_ca_certificates}.pem ${STAGE_PATH}/share/cacert.pem
  try cp $BUILD_PATH/ca_certificates/build-$ARCH/cacert-${VERSION_ca_certificates}.pem ${STAGE_PATH}/etc/cert.pem

  pop_env
}

# function called after all the compile have been done
function postbuild_ca_certificates() {
  :
}

# function to append information to config file
function add_config_info_ca_certificates() {
  append_to_config_file "# ca_certificates-${VERSION_ca_certificates}: ${DESC_ca_certificates}"
  append_to_config_file "export VERSION_ca_certificates=${VERSION_ca_certificates}"
}