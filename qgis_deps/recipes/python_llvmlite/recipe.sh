#!/bin/bash

DESC_python_llvmlite="python llvmlite"

# version of your package
# need to be in sync, see https://llvmlite.readthedocs.io/en/latest/admin-guide/install.html
VERSION_llvm=9.0.1
VERSION_python_llvmlite=0.33.0

# dependencies of this recipe
DEPS_python_llvmlite=(python python_packages python_numpy python_pillow openblas)

# url of the package
URL_python_llvmlite=https://github.com/numba/llvmlite/archive/v${VERSION_python_llvmlite}.tar.gz
URL_llvm=https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION_llvm}/llvm-${VERSION_llvm}.src.tar.xz

# md5 of the package
MD5_python_llvmlite=2ffb8cfa38d25343415a83180682e1bf
MD5_llvm=31eb9ce73dd2a0f8dcab8319fb03f8fc

# default build path
BUILD_python_llvmlite=$BUILD_PATH/python_llvmlite/$(get_directory $URL_python_llvmlite)
BUILD_llvm=$BUILD_PATH/python_llvmlite/llvm-$VERSION_llvm.src

# default recipe path
RECIPE_python_llvmlite=$RECIPES_PATH/python_llvmlite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_llvmlite() {
  cd $BUILD_python_llvmlite

  download_file python_llvmlite ${URL_llvm} ${MD5_llvm} 0

  try cp $BUILD_python_llvmlite/conda-recipes/llvm-lto-static.patch $BUILD_llvm/
  try cp $BUILD_python_llvmlite/conda-recipes/partial-testing.patch $BUILD_llvm/
  try cp $BUILD_python_llvmlite/conda-recipes/intel-D47188-svml-VF.patch $BUILD_llvm/
  try cp $BUILD_python_llvmlite/conda-recipes/0001-Revert-Limit-size-of-non-GlobalValue-name.patch $BUILD_llvm/

  cd $BUILD_llvm/
  try patch -p1 -i llvm-lto-static.patch
  try patch -p1 -i partial-testing.patch
  try patch -p1 -i intel-D47188-svml-VF.patch
  try patch -p1 -i 0001-Revert-Limit-size-of-non-GlobalValue-name.patch

  cd $BUILD_python_llvmlite
}

function shouldbuild_python_llvmlite() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed llvmlite; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_llvmlite() {
   if ! python_package_installed_verbose llvmlite; then
      error "Missing python package llvmlite"
   fi
}

# function to append information to config file
function add_config_info_python_llvmlite() {
  append_to_config_file "# python_llvmlite-${VERSION_python_llvmlite}: ${DESC_python_llvmlite}"
  append_to_config_file "export VERSION_python_llvmlite=${VERSION_python_llvmlite}"
  append_to_config_file "export VERSION_llvm=${VERSION_llvm}"
}