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
BUILD_python_packages=${DEPS_BUILD_PATH}/python_packages/v${VERSION_python_packages}

# default recipe path
RECIPE_python_packages=$RECIPES_PATH/python_packages

# requirements
# ORDER matters!
REQUIREMENTS_python_packages=(
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
    attrs==19.3.0
    pyrsistent==0.16.0
    jsonschema==3.2.0
    traitlets==4.3.3
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
    pypubsub==3.3.0
    pytz==2019.3
    pyyaml==5.3.1
    urllib3==1.24.3
    requests==2.23.0
    retrying==1.3.3
    simplejson==3.17.0
    termcolor==1.1.0
    lxml==4.5.2
    tools==0.1.9
    xlrd==1.2.0
    xlwt==1.3.0
    joblib==0.16.0
    threadpoolctl==2.1.0
    cryptography==3.0
    cffi==1.14.1
    pycparser==2.20
    pyopenssl==19.1.0
    pyodbc==4.0.30
    plotly==4.6.0
    access==1.1.1
    esda==2.3.1
    giddy==2.3.3
    inequality==1.0.0
    pointpats==2.2.0
    segregation==1.3.0
    spaghetti==1.5.0
    mgwr==2.1.1
    spglm==1.0.7
    spint==1.0.6
    spreg==1.1.2.post1
    spvcm==0.3.0
    tobler==0.3.1
    mapclassify==2.3.0
    splot==1.1.3
    iniconfig==1.0.1
    more-itertools==8.4.0
    packaging==20.4
    pluggy==0.13.1
    py==1.9.0
    toml==0.10.1
    pytest==6.0.1
    pytest-cov==2.10.0
    beautifulsoup4==4.10.0
    Sphinx==2.4.3
    quantecon==0.4.8
    tqdm==4.48.2
    seaborn==0.10.1
    click==7.1.2
    click-plugins==1.1.1
    cligj==0.5.0
    munch==2.5.0
    appdirs==1.4.4
    distlib==0.3.1
    filelock==3.0.12
    pipenv==2020.6.2
    virtualenv==20.0.30
    virtualenv-clone==0.5.4
    importlib-metadata==1.7.0
    zipp==3.1.0
    rasterstats==0.15.0
    clipboard==0.0.4
    pyperclip==1.8.1
    pyvenv==0.2.2
    snuggs==1.4.7
    affine==2.3.0
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


}

function shouldbuild_python_packages() {
  if python_package_installed yaml; then
    DO_BUILD=0
  fi
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