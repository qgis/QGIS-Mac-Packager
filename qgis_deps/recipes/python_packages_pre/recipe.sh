#!/bin/bash

# Pa
DESC_python_packages_pre="Common packages for python (pre)"

# version of your package (set in config.conf)
VERSION_python_packages_pre=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages_pre=(python python_sip python_pyqt5 little_cms2)

# url of the package
URL_python_packages_pre=

# md5 of the package
MD5_python_packages_pre=

# default build path
BUILD_python_packages_pre=$BUILD_PATH/python_packages_pre/v${VERSION_python_packages_pre}

# default recipe path
RECIPE_python_packages_pre=$RECIPES_PATH/python_packages_pre

# requirements
# ORDER matters!
REQUIREMENTS_python_packages_pre=(
    six==1.14.0
    python-dateutil==2.8.0
    cython==0.29.21
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
    pygments==2.6.1
    pyparsing==2.4.7
    pypubsub==4.0.3
    pytz==2019.3
    pyyaml==5.3.1
    urllib3==1.24.3
    requests==2.23.0
    retrying==1.3.3
    simplejson==3.17.0
    termcolor==1.1.0
    tools==0.1.9
    traitlets==4.3.3
    xlrd==1.2.0
    xlwt==1.3.0
    joblib==0.16.0
    threadpoolctl==2.1.0
)

IMPORTS_python_packages_pre=(
  six
  requests
  dateutil
  yaml
)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_packages_pre() {
  try mkdir -p $BUILD_python_packages_pre
  cd $BUILD_python_packages_pre

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_packages_pre() {
  if python_package_installed requests; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_packages_pre() {
  try mkdir -p $BUILD_PATH/python_packages_pre/build-$ARCH
  try cd $BUILD_PATH/python_packages_pre/build-$ARCH

  push_env

  for i in ${REQUIREMENTS_python_packages_pre[*]}
  do
    info "Installing python_packages_pre package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    # this does not force --no-binary all strictly
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP install $i
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_python_packages_pre() {
 for i in ${IMPORTS_python_packages_pre[*]}
  do
    if ! python_package_installed $i ; then
      error "Missing python package $i (pre)"
    fi
  done
}

# function to append information to config file
function add_config_info_python_packages_pre() {
  append_to_config_file "# python_packages_pre-${VERSION_python_package}: ${DESC_python_package}"
  for i in ${REQUIREMENTS_python_packages_pre[*]}
  do
    arr=(${i//==/ })
    append_to_config_file "export VERSION_python_packages_pre_${arr[0]//-/_}=${arr[1]}"
  done
}