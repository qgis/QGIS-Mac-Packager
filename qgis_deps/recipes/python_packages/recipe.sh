#!/bin/bash

DESC_python_packages="Packages for python"

# version of your package (set in config.conf)
VERSION_python_packages=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages=(python hdf5 python_sip python_pyqt5)

# url of the package
URL_python_packages=

# md5 of the package
MD5_python_packages=

# default build path
BUILD_python_packages=$BUILD_PATH/python_packages/v${VERSION_python_packages}

# default recipe path
RECIPE_python_packages=$RECIPES_PATH/python_packages

# requirements
# ORDER matters!
REQUIREMENTS_python_packages=(
    six==1.14.0
    python-dateutil==2.8.0
    cython==0.29.16
    decorator==4.4.2
    coverage==5.1
    nose2==0.9.2
    certifi==2020.4.5.1
    chardet==3.0.4
    cycler==0.10.0
    exifread==2.1.2
    funcsigs==1.0.2
    future==0.18.2
    httplib2==0.17.2
    idna==2.9
    ipython-genutils==0.2.0
    markupsafe==1.1.1
    jinja2==2.11.2
    jsonschema==3.2.0
    jupyter-core==4.6.3
    kiwisolver==1.2.0
    mock==4.0.2
    nbformat==5.0.5
    networkx==2.4
    oauthlib==3.1.0
    pbr==5.4.5
    ply==3.11
    psycopg2==2.8.5
    pyopenssl==19.1.0
    pygments==2.6.1
    pyodbc==4.0.30
    pyparsing==2.4.7
    pypubsub==4.0.3
    pytz==2019.3
    pyyaml==5.3.1
    urllib3==1.24.3
    requests==2.23.0
    retrying==1.3.3
    shapely==1.7.0
    simplejson==3.17.0
    termcolor==1.1.0
    tools==0.1.9
    traitlets==4.3.3
    xlrd==1.2.0
    xlwt==1.3.0
    pysal==2.2.0
    numpy==1.18.2
    scipy==1.4.1
    pandas==1.0.3
    plotly==4.6.0
    pillow==7.1.1
    matplotlib==3.2.1
)

IMPORTS_python_packages=(
  six
  numpy
  requests
  dateutil
  yaml
  shapely
  plotly
  matplotlib
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
    # this does not force --no-binary all strictly
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP install $i
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