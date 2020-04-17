#!/bin/bash

function check_python_packages() {
  env_var_exists VERSION_python_packages
  env_var_exists DEPS_PYTHON_SITE_PACKAGES_DIR
  env_var_exists BUNDLE_PYTHON_SITE_PACKAGES_DIR
}

function bundle_python_packages() {
   try rsync -av $DEPS_PYTHON_SITE_PACKAGES_DIR/ $BUNDLE_PYTHON_SITE_PACKAGES_DIR/ --exclude __pycache__
}

function postbundle_python_packages() {
    :
}

function add_config_info_python_packages() {
    :
}
