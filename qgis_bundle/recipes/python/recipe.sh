#!/bin/bash

function check_python() {
  env_var_exists VERSION_python
}

function bundle_python() {
    : # install_name_tool -id "@rpath/libpython.dylib" ${STAGE_PATH}/lib/libpython.dylib
}

function postbundle_python() {
    :
}

function add_config_info_python() {
    :
}

patch_python_linker_links () {
  if [ ! -f "${STAGE_PATH}/lib/libpython${VERSION_major_python}m.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libpython${VERSION_major_python}m.dylib does not exist... maybe you updated the python version?"
  fi

  chmod +w ${STAGE_PATH}/lib/libpython${VERSION_major_python}m.dylib
  install_name_tool -id "@rpath/libpython${VERSION_major_python}m.dylib" "${STAGE_PATH}/lib/libpython${VERSION_major_python}m.dylib"

  targets=(
    bin/python3
  )
  for i in ${targets[*]}
  do
      install_name_tool -change "${STAGE_PATH}/lib/libpython${VERSION_major_python}m.dylib" "@rpath/libpython${VERSION_major_python}m.dylib" ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done

  PYMODULES=`find $STAGE_PATH/lib/python3.7/lib-dynload -type f -name "*.so"`

  for i in $PYMODULES; do
    install_name_tool -add_rpath @loader_path/../../ $i
  done
}
