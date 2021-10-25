#!/bin/bash

GDAL_EGG_DIR=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/

# REMOVE when qgis-deps-0.9 is used everywhere
if [ "${VERSION_python_gdal:0:3}" = "3.2" ]; then
  PYGDAL_SCRIPTS=(
    epsg_tr.py \
    esri2wkt.py \
    gcps2vec.py \
    gcps2wld.py \
    gdal2tiles.py \
    gdal2xyz.py \
    gdal_auth.py \
    gdal_calc.py \
    gdal_edit.py \
    gdal_fillnodata.py \
    gdal_merge.py \
    gdal_pansharpen.py \
    gdal_polygonize.py \
    gdal_proximity.py \
    gdal_retile.py \
    gdal_sieve.py \
    gdalchksum.py \
    gdalcompare.py \
    gdalident.py \
    gdalimport.py \
    gdalmove.py \
    mkgraticule.py \
    ogrmerge.py \
    pct2rgb.py \
    rgb2pct.py \
  )
else
  PYGDAL_SCRIPTS=(
    gdal2tiles.py \
    gdal2xyz.py \
    gdal_calc.py \
    gdal_edit.py \
    gdal_fillnodata.py \
    gdal_merge.py \
    gdal_pansharpen.py \
    gdal_polygonize.py \
    gdal_proximity.py \
    gdal_retile.py \
    gdal_sieve.py \
    gdalcompare.py \
    gdalmove.py \
    ogrmerge.py \
    pct2rgb.py \
    rgb2pct.py \
    gdalattachpct.py
)
fi

function check_python_gdal() {
  env_var_exists VERSION_python_gdal
}

function bundle_python_gdal() {
  for i in "${PYGDAL_SCRIPTS[@]}"
  do
    try cp -av $DEPS_BIN_DIR/$i $BUNDLE_BIN_DIR/$i
  done
}

function fix_binaries_python_gdal() {
  for i in \
    _osr \
    _gdal_array \
    _gdal \
    _ogr \
    _gnm \
    _gdalconst
  do
    install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $GDAL_EGG_DIR/osgeo/$i.cpython-${VERSION_major_python//./}-darwin.so
  done
}

function fix_binaries_python_gdal_check() {
  verify_binary $GDAL_EGG_DIR/osgeo/_gdal.cpython-${VERSION_major_python//./}-darwin.so
}

function fix_paths_python_gdal() {
  for i in "${PYGDAL_SCRIPTS[@]}"
  do
    fix_python_exec_link $GDAL_EGG_DIR/EGG-INFO/scripts/$i
    fix_python_exec_link $BUNDLE_BIN_DIR/$i
  done
}

function fix_paths_python_gdal_check() {
  for i in "${PYGDAL_SCRIPTS[@]}"
  do
    verify_file_paths $BUNDLE_BIN_DIR/$i
    verify_file_paths $GDAL_EGG_DIR/EGG-INFO/scripts/$i
  done
}

