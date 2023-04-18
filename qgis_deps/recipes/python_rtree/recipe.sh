#!/bin/bash

DESC_python_rtree="Python bindings for libspatialindex"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_rtree=1.0.1

# dependencies of this recipe
DEPS_python_rtree=(python python_packages spatialindex)

# url of the package
URL_python_rtree=https://github.com/Toblerity/rtree/archive/${VERSION_python_rtree}.tar.gz

# md5 of the package
MD5_python_rtree=c70d72aa1cfa232aac945735da364e9d

# default build path
BUILD_python_rtree=$BUILD_PATH/python_rtree/$(get_directory $URL_python_rtree)

# default recipe path
RECIPE_python_rtree=$RECIPES_PATH/python_rtree

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_rtree() {
  cd $BUILD_python_rtree

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_rtree() {
  if python_package_installed rtree; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_rtree() {
  try rsync -a $BUILD_python_rtree/ $BUILD_PATH/python_rtree/build-$ARCH/
  try cd $BUILD_PATH/python_rtree/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  # see https://github.com/qgis/QGIS-Mac-Packager/issues/80
  cd $STAGE_PATH/lib/python${VERSION_major_python}/site-packages/Rtree-${VERSION_python_rtree}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/rtree
  if [ -f _core.py ]; then
    info "python_rtree core.py already patched"
  else
    info "patching core.py for python_rtree"
    try mv core.py _core.py
    try cp $RECIPE_python_rtree/core.py core.py
  fi

  pop_env
}

# function called after all the compile have been done
function postbuild_python_rtree() {
  if ! python_package_installed_verbose rtree; then
      error "Missing python package rtree"
  fi
}

# function to append information to config file
function add_config_info_python_rtree() {
  append_to_config_file "# python_rtree-${VERSION_python_rtree}: ${DESC_python_rtree}"
  append_to_config_file "export VERSION_python_rtree=${VERSION_python_rtree}"
}