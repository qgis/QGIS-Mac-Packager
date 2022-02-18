#!/bin/bash

DESC_python_pymssql="Python binding of MSSQL"

# version of your package
# need to keep in sync with hdf5
VERSION_python_pymssql=2.1.5

# dependencies of this recipe
DEPS_python_pymssql=(python freetds python_packages)

# url of the package
URL_python_pymssql=

# md5 of the package
MD5_python_pymssql=

# default build path
BUILD_python_pymssql=${DEPS_BUILD_PATH}/python_pymssql/v${VERSION_python_pymssql}

# default recipe path
RECIPE_python_pymssql=$RECIPES_PATH/python_pymssql

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pymssql() {
  mkdir -p $BUILD_python_pymssql
  cd $BUILD_python_pymssql


}

function shouldbuild_python_pymssql() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed pymssql; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_pymssql() {
   if ! python_package_installed_verbose pymssql; then
      error "Missing python package pymssql"
   fi
}

# function to append information to config file
function add_config_info_python_pymssql() {
  append_to_config_file "# python_pymssql-${VERSION_python_pymssql}: ${DESC_python_pymssql}"
  append_to_config_file "export VERSION_python_pymssql=${VERSION_python_pymssql}"
}