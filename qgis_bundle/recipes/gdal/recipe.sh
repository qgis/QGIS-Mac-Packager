#!/bin/bash

function check_gdal() {
  env_var_exists VERSION_gdal
}

function bundle_gdal() {
  try rsync -av $DEPS_SHARE_DIR/gdal $BUNDLE_RESOURCES_DIR/
}

function postbundle_gdal() {
    : # install_name_tool -id "@rpath/libgdal.dylib" ${STAGE_PATH}/lib/libgdal.dylib
}

function add_config_info_gdal() {
    :
}

patch_gdal_linker_links () {
  install_name_tool -id "@rpath/libgdal.dylib" ${STAGE_PATH}/lib/libgdal.dylib

  # check libs are the same
  if [ ! -f "${STAGE_PATH}/lib/libgdal.${LINK_libgdal_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libgdal.${LINK_libgdal_version}.dylib does not exist... maybe you updated the gdal version?"
  fi

  targets=(
    bin/nearblack
    bin/gdal-config
    bin/gdal_contour
    bin/gdal_grid
    bin/gdal_rasterize
    bin/gdal_translate
    bin/gdaladdo
    bin/gdalbuildvrt
    bin/gdaldem
    bin/gdalenhance
    bin/gdalinfo
    bin/gdallocationinfo
    bin/gdalmanage
    bin/gdalserver
    bin/gdalsrsinfo
    bin/gdaltindex
    bin/gdaltransform
    bin/gdalwarp
    bin/ogr2ogr
    bin/ogrinfo
    bin/ogrlineref
    bin/ogrtindex
    bin/testepsg
    bin/gnmanalyse
    bin/gnmmanage
  )

  # Change linked libs
  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libgdal.${LINK_libgdal_version}.dylib" "@rpath/libgdal.${LINK_libgdal_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}
