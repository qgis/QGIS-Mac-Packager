#!/bin/bash

function check_python_pyqt5() {
  env_var_exists VERSION_python_pyqt5
}

function bundle_python_pyqt5() {
    : # install_name_tool -id "@rpath/libpython_pyqt5.dylib" ${STAGE_PATH}/lib/libpython_pyqt5.dylib
}

function postbundle_python_pyqt5() {
    :
}

function add_config_info_python_pyqt5() {
    :
}

function fix_python_pyqt5_paths() {

  # these are sh scripts that calls plain python{VERSION_major_python}
  # so when on path there is homebrew python or other
  # it fails
  targets=(
    bin/pylupdate5
    bin/pyrcc5
    bin/pyuic5
  )

  for i in ${targets[*]}
  do
    try ${SED} 's;exec python${VERSION_major_python};exec `dirname $0`/python${VERSION_major_python};g' $STAGE_PATH/$i
    # remove backup file
    rm -f $STAGE_PATH/$i.orig
  done

  # TODO fix bash scripts to not use abs path!
}
