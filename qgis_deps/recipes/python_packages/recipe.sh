#!/bin/bash

# Pa
DESC_python_packages="Common packages for python (pre)"

# version of your package (set in config.conf)
VERSION_python_packages=${VERSION_python}

# dependencies of this recipe
DEPS_python_packages=(python python_sip python_pyqt5 little_cms2 libyaml)

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
    six==1.16.0
    python-dateutil==2.8.2
    cython==0.29.34
    decorator==5.1.1
    coverage==7.2.3
    nose2==0.12.0
    certifi==2022.12.7
    chardet==5.1.0
    cycler==0.11.0
    exifread==3.0.0
    funcsigs==1.0.2
    future==0.18.3
    httplib2==0.22.0
    idna==3.4
    ipython-genutils==0.2.0
    markupsafe==2.1.2
    jinja2==3.1.2
    attrs==23.1.0
    pyrsistent==0.19.3
    jsonschema==4.17.3
    traitlets==5.9.0
    jupyter-core==5.3.0
    kiwisolver==1.4.4
    mock==5.0.2
    nbformat==5.8.0
    networkx==3.1
    oauthlib==3.2.2
    pbr==5.11.1
    ply==3.11
    pygments==2.15.0
    pyparsing==3.0.9
    pypubsub==3.3.0
    pytz==2023.3
    pyyaml==6.0
    urllib3==1.26.15
    requests==2.28.2
    retrying==1.3.4
    simplejson==3.19.1
    termcolor==2.2.0
    lxml==4.9.2
    tools==0.1.9
    xlrd==2.0.1
    xlwt==1.3.0
    joblib==1.2.0
    threadpoolctl==3.1.0
    cryptography==3.0
    cffi==1.15.1
    pycparser==2.21
    pyopenssl==23.1.1
    giddy==2.3.4
    inequality==1.0.0
    pointpats==2.3.0
    spaghetti==1.7.2
    mgwr==2.1.2
    spglm==1.0.8
    spint==1.0.7
    spvcm==0.3.0
    mapclassify==2.5.0
    iniconfig==2.0.0
    more-itertools==9.1.0
    packaging==23.1
    pluggy==1.0.0
    py==1.11.0
    toml==0.10.2
    pytest==7.3.1
    pytest-cov==4.0.0
    beautifulsoup4==4.12.2
    Sphinx==6.1.3
    quantecon==0.6.0
    tqdm==4.65.0
    seaborn==0.12.2
    click==8.1.3
    click-plugins==1.1.1
    cligj==0.7.2
    munch==2.5.0
    appdirs==1.4.4
    distlib==0.3.6
    filelock==3.11.0
    pipenv==2023.3.20
    virtualenv==20.21.0
    virtualenv-clone==0.5.7
    importlib-metadata==6.4.1
    zipp==3.15.0
    rasterstats==0.18.0
    clipboard==0.0.4
    pyperclip==1.8.2
    pyvenv==0.2.2
    snuggs==1.4.7
    affine==2.4.0
)

# pyodbc build may fail
REQUIREMENTS_python_packages_without_build=(
  pyodbc==4.0.39
  plotly==5.14.1
  access==1.1.9
  esda==2.4.3
  segregation==2.3.1
  spreg==1.3.2
  tobler==0.9.0
  splot==1.1.5.post1
)

IMPORTS_python_packages=(
  six
  requests
  dateutil
  yaml
  affine
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
  if python_package_installed affine; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_packages() {
  try mkdir -p $BUILD_PATH/python_packages/build-$ARCH
  try cd $BUILD_PATH/python_packages/build-$ARCH

  push_env

  export LDFLAGS="-L${STAGE_PATH}/unixodbc/lib"
  export CPPFLAGS="-I${STAGE_PATH}/unixodbc/include"
  for i in ${REQUIREMENTS_python_packages_without_build[*]}
  do
    info "Installing python_packages package $i without build"
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP install $i
  done
  unset LDFLAGS
  unset CPPFLAGS

  for i in ${REQUIREMENTS_python_packages[*]}
  do
    info "Installing python_packages package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    # this does not force --no-binary all strictly
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY install $i
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_python_packages() {
 for i in ${IMPORTS_python_packages[*]}
  do
    if ! python_package_installed_verbose $i ; then
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