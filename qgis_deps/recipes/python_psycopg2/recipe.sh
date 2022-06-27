#!/bin/bash

DESC_python_psycopg2="Python-PostgreSQL Database Adapter"


DEPS_python_psycopg2=(python postgres python_packages python_scipy)

# default build path
BUILD_python_psycopg2=${DEPS_BUILD_PATH}/python_psycopg2/v${VERSION_python_psycopg2}

# default recipe path
RECIPE_python_psycopg2=$RECIPES_PATH/python_psycopg2

# function called after all the compile have been done
function postbuild_python_psycopg2() {
   if ! python_package_installed_verbose psycopg2; then
      error "Missing python package psycopg2"
   fi
}

# function to append information to config file
function add_config_info_python_psycopg2() {
  append_to_config_file "# python_psycopg2-${VERSION_python_psycopg2}: ${DESC_python_psycopg2}"
  append_to_config_file "export VERSION_python_psycopg2=${VERSION_python_psycopg2}"
}