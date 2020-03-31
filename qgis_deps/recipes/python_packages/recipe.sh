#!/bin/bash

DESC_python_packages="Packages for python"

# version of your package (set in config.conf)
VERSION_python_packages=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages=(python hdf5 python_sip python_pyqt5 python_qscintilla )

# url of the package
URL_python_packages=

# md5 of the package
MD5_python_packages=

# default build path
BUILD_python_packages=$BUILD_PATH/python_packages/v${VERSION_python_packages}

# default recipe path
RECIPE_python_packages=$RECIPES_PATH/python_packages

# requirements
# TODO
# pip3 install --no-binary=pyproj pyproj==1.9.6
# pip3 install --no-binary=shapely shapely
# pip3 install --no-binary=GDAL GDAL==2.4.0
# pip3 install certifi
#pip3 install chardet
#pip3 install idna
#pip3 install OWSLib
#pip3 install cython
#pip3 install pytz
#pip3 install urllib3
#pip3 install coverage
#pip3 install funcsigs
#pip3 install future
#pip3 install mock
#pip3 install nose2
#pip3 install pbr
#pip3 install psycopg2
#pip3 install Jinja2
#pip3 install MarkupSafe
#pip3 install Pygments
#pip3 install termcolor
#pip3 install oauthlib
#pip3 install pyOpenSSL
#pip3 install numpy
#pip3 install certifi
#pip3 install chardet
#pip3 install coverage
#pip3 install cycler
#pip3 install decorator
#pip3 install exifread
#pip3 install future
#pip3 install httplib2
#pip3 install idna
#pip3 install ipython-genutils
#pip3 install jinja2
#pip3 install jsonschema
#pip3 install jupyter-core
#pip3 install kiwisolver
#pip3 install markupsafe
#pip3 install matplotlib
#pip3 install mock
#pip3 install mock
#pip3 install nbformat
#pip3 install networkx
#pip3 install nose2
#pip3 install numpy
#pip3 install owslib
#pip3 install pandas
#pip3 install pbr
#pip3 install plotly
#pip3 install ply
#pip3 install psycopg2
#pip3 install pygments
#pip3 install pyodbc
#pip3 install pyparsing
#pip3 install pypubsub
#pip3 install pysal
#pip3 install pytz
#pip3 install retrying
#pip3 install scipy
#pip3 install simplejson
#pip3 install test
#pip3 install tools
#pip3 install traitlets
#pip3 install urllib3
#pip3 install xlrd
#pip3 install xlwt
#   Pillow==7.0.0

REQUIREMENTS_python_packages=(
  six==1.14.0
  numpy==1.18.2
  h5py==2.10.0
  requests==2.23.0
  python-dateutil==2.8.1
  PyYAML==5.3.1
)

IMPORTS_python_packages=(
  six
  numpy
  h5py
  requests
  dateutil
  yaml
)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_packages() {
  try mkdir -p $BUILD_python_packages
  cd $BUILD_python_packages

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_packages() {
  if python_package_installed h5py; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_packages() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  for i in ${REQUIREMENTS_python_packages[*]}
  do
    info "Installing python_packages package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP $i
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_python_packages() {
 for i in ${IMPORTS_python_packages[*]}
  do
    if ! python_package_installed $i ; then
      error "Missing python package $i"
    fi
  done
}

# function to append information to config file
function add_config_info_python_packages() {
  append_to_config_file "# python_packages-${VERSION_python_package}: ${DESC_python_package}"
  for i in ${REQUIREMENTS_python_packages[*]}
  do
    arr=(${i//==/ })
    append_to_config_file "export VERSION_python_packages_${arr[0]//-/_}=${arr[1]}"
  done
}