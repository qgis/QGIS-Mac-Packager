#!/bin/bash

DESC_python_packages="Common packages for python (pre)"

DEPS_python_packages=(python python_sip python_pyqt5 little_cms2 libyaml)

# default build path
BUILD_python_packages=${DEPS_BUILD_PATH}/python_packages/v${VERSION_python_packages}

# default recipe path
RECIPE_python_packages=$RECIPES_PATH/python_packages

# requirements
# ORDER matters!
REQUIREMENTS_python_packages=(
    six==1.16.0
    python-dateutil==2.8.2
    cython==0.29.32
    decorator==5.1.1
    coverage==6.3.2
    nose2==0.11.0
    certifi==2021.10.8
    chardet==3.0.4
    cycler==0.11.0
    exifread==2.3.2
    funcsigs==1.0.2
    future==0.18.2
    httplib2==0.20.4
    idna==3.3
    ipython-genutils==0.2.0
    markupsafe==2.1.1
    jinja2==3.0.3
    attrs==21.4.0
    pyrsistent==0.18.1
    jsonschema==4.4.0
    traitlets==5.1.1
    jupyter-core==4.9.2
    jupyterlab==3.3.2
    mock==4.0.3
    nbformat==5.2.0
    networkx==2.7.1
    oauthlib==3.2.0
    pbr==5.8.1
    ply==3.11
    pygments==2.11.2
    pyparsing==3.0.7
    pytz==2022.1
    pyyaml==6.0
    urllib3==1.26.9
    requests==2.27.1
    retrying==1.3.3
    simplejson==3.17.6
    termcolor==1.1.0
    lxml==4.8.0
    tools==0.1.9
    xlrd==2.0.1
    xlwt==1.3.0
    joblib==1.1.0
    threadpoolctl==3.1.0
    cffi==1.15.0
    pycparser==2.21
    pyopenssl==22.0.0
    pyodbc==4.0.32
    plotly==4.14.3
    access==1.1.3
    esda==2.4.1
    giddy==2.3.3
    inequality==1.0.0
    pointpats==2.2.0
    segregation==2.1.0
    mgwr==2.1.2
    spglm==1.0.8
    spint==1.0.7
    spreg==1.2.4
    spvcm==0.3.0
    mapclassify==2.4.3
    splot==1.1.4
    iniconfig==1.1.1
    more-itertools==8.12.0
    packaging==21.3
    pluggy==1.0.0
    py==1.11.0
    toml==0.10.2
    pytest==7.1.1
    pytest-cov==3.0.0
    beautifulsoup4==4.10.0
    Sphinx==4.4.0
    quantecon==0.5.2
    tqdm==4.63.0
    seaborn==0.11.2
    click==8.0.4
    click-plugins==1.1.1
    cligj==0.7.2
    munch==2.5.0
    appdirs==1.4.4
    distlib==0.3.4
    filelock==3.6.0
    pipenv==2022.1.8
    virtualenv==20.13.4
    virtualenv-clone==0.5.7
    importlib-metadata==4.11.3
    zipp==3.7.0
    rasterstats==0.16.0
    clipboard==0.0.4
    pyperclip==1.8.2
    pyvenv==0.2.2
    snuggs==1.4.7
    affine==2.3.0
    fonttools==4.31.2
    cppy==1.2.1
    kiwisolver==1.4.3
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
