#!/bin/bash

DESC_python="Interpreted, interactive, object-oriented programming language"

LINK_python=libpython${VERSION_major_python}.dylib

DEPS_python=(openssl xz libffi zlib libzip sqlite expat unixodbc bz2 gettext libcurl)

# default build path
BUILD_python=${DEPS_BUILD_PATH}/python/$(get_directory $URL_python)

# default recipe path
RECIPE_python=$RECIPES_PATH/python

# requirements
REQUIREMENTS_python=(
  setuptools==https://files.pythonhosted.org/packages/9a/74/de4d8c69466b6413b1616048b39f8b73d65f98c15f6202b68ccfc9550f1f/setuptools-58.0.4.tar.gz==17245af34e1a7d54976bca8c1bf092b7
  pip==https://files.pythonhosted.org/packages/52/e1/06c018197d8151383f66ebf6979d951995cf495629fc54149491f5d157d0/pip-21.2.4.tar.gz==efbdb4201a5e6383fb4d12e26f78f355
  wheel==https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz==79f55b898e6f274f5586bbde39f6fe8e
)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python() {
  cd $BUILD_python

  patch_configure_file configure
  try rsync -a $BUILD_python/ ${DEPS_BUILD_PATH}/python/build-$ARCH/
}



# function called after all the compile have been done
function postbuild_python() {
  verify_binary bin/python3
  verify_binary lib/$LINK_python

  if ! python_package_installed bz2; then
    error "Missing python bz2, probably libbz2 was not picked by compilation of python"
  fi
}

function postbuild_wheel() {
  :
}

# function to append information to config file
function add_config_info_python() {
  append_to_config_file "# python-${VERSION_python}: ${DESC_python}"
  append_to_config_file "export VERSION_python=${VERSION_python}"
  append_to_config_file "export LINK_python=${LINK_python}"
}
