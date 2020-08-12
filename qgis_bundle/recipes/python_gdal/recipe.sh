#!/bin/bash

function check_python_gdal() {
  env_var_exists VERSION_python_gdal
}

function bundle_python_gdal() {
  for i in \
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
    rgb2pct.py
  do
    try cp -av $DEPS_BIN_DIR/$i $BUNDLE_BIN_DIR/$i
  done
}

function postbundle_python_gdal() {
  GDAL_EGG_DIR=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/

  for i in \
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
    rgb2pct.py
  do
    fix_exec_link $QGIS_DEPS_STAGE_PATH/bin/python3 python3 $GDAL_EGG_DIR/EGG-INFO/scripts/$i
    fix_exec_link $QGIS_DEPS_STAGE_PATH/bin/python3 python3 $BUNDLE_BIN_DIR/$i
  done

  for i in \
    _osr \
    _gdal_array \
    _gdal \
    _ogr \
    _gnm \
    _gdalconst
  do
    install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $GDAL_EGG_DIR/osgeo/$i.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

