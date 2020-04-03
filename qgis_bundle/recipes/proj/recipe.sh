#!/bin/bash

function check_proj() {
  env_var_exists VERSION_proj
}

function bundle_proj() {
  try rsync -av $DEPS_SHARE_DIR/proj $BUNDLE_RESOURCES_DIR/
}

function postbundle_proj() {
    : # install_name_tool -id "@rpath/libproj.dylib" ${STAGE_PATH}/lib/libproj.dylib
}

function add_config_info_proj() {
    :
}

patch_proj_linker_links () {
  targets=(
    bin/proj
    bin/gie
    bin/geod
    bin/projinfo
    bin/cct
    bin/cs2cs
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/proj/build-$ARCH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}
