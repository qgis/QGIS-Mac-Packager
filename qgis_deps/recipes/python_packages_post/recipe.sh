#!/bin/bash

# These packages are installed after python_packages_pre AND all python_*
DESC_python_packages_post="Common packages for python (post)"

# version of your package (set in config.conf)
VERSION_python_packages_post=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages_post=(python python_packages_pre python_matplotlib python_llvmlite python_statsmodels python_gdal python_opencv python_scikit_learn python_pyproj python_h5py python_netcdf4 python_numpy python_owslib python_pyqt5 python_scikit_learn python_qscintilla python_sip python_pillow python_scipy python_shapely)

# url of the package
URL_python_packages_post=

# md5 of the package
MD5_python_packages_post=

# default build path
BUILD_python_packages_post=$BUILD_PATH/python_packages_post/v${VERSION_python_packages_post}

# default recipe path
RECIPE_python_packages_post=$RECIPES_PATH/python_packages_post

# requirements
# ORDER matters!
REQUIREMENTS_python_packages_post=(
    psycopg2==2.8.5
    pyopenssl==19.1.0
    pyodbc==4.0.30
    plotly==4.6.0
    pysal==2.2.0
)

IMPORTS_python_packages_post=(
  plotly
)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_packages_post() {
  try mkdir -p $BUILD_python_packages_post
  cd $BUILD_python_packages_post

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_packages_post() {
  if python_package_installed plotly; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_packages_post() {
  try mkdir -p $BUILD_PATH/python_packages_post/build-$ARCH
  try cd $BUILD_PATH/python_packages_post/build-$ARCH

  push_env

  for i in ${REQUIREMENTS_python_packages_post[*]}
  do
    info "Installing python_packages_post package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    # this does not force --no-binary all strictly
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY install $i
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_python_packages_post() {
 for i in ${IMPORTS_python_packages_post[*]}
  do
    if ! python_package_installed $i ; then
      error "Missing python package $i (post)"
    fi
  done
}

# function to append information to config file
function add_config_info_python_packages_post() {
  append_to_config_file "# python_packages_post-${VERSION_python_package}: ${DESC_python_package}"
  for i in ${REQUIREMENTS_python_packages_post[*]}
  do
    arr=(${i//==/ })
    append_to_config_file "export VERSION_python_packages_post_${arr[0]//-/_}=${arr[1]}"
  done
}