#!/bin/bash

function check_grass() {
  env_var_exists VERSION_grass
  env_var_exists DEPS_GRASS_LIB_DIR
}

function bundle_grass() {
	try cp -av $DEPS_GRASS_LIB_DIR/libgrass_*dylib $BUNDLE_LIB_DIR
}

function postbundle_grass() {
 # libgrass_gis
 install_name_id  @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib



 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_manage.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dig2.7.8.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rowio.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_btree2.7.8.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_arraystats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_calc.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rli.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dspf.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_segment.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_symb.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_vector
 install_name_id  @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib


 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_manage.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_raster
 install_name_id  @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib


 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_calc.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rli.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_imagery
 install_name_id  @rpath/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib


 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dbmibase
 install_name_id  @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib


 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmibase.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dbmiclient
 install_name_id  @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib


 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbmiclient.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_gproj
 install_name_id  @rpath/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib


 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_rtree
 install_name_id  @rpath/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dig2.7.8.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_rtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_linkm
 install_name_id  @rpath/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_manage
 install_name_id  @rpath/libgrass_manage.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_manage.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_cluster
 install_name_id  @rpath/libgrass_cluster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_arraystats
 install_name_id  @rpath/libgrass_arraystats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_arraystats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_stats
 install_name_id  @rpath/libgrass_stats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_calc
 install_name_id  @rpath/libgrass_calc.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_calc.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dbstubs
 install_name_id  @rpath/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

  # libgrass_dig2
 install_name_id  @rpath/libgrass_dig2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dig2.7.8.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dig2.7.8.dylib @rpath/libgrass_dig2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_ccmath
 install_name_id  @rpath/libgrass_ccmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_ccmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_ccmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_ccmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_rowio
 install_name_id  @rpath/libgrass_rowio.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rowio.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_btree2
 install_name_id  @rpath/libgrass_btree2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_btree2.7.8.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_btree2.7.8.dylib @rpath/libgrass_btree2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_btree2.7.8.dylib @rpath/libgrass_btree2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_segment.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_qtree
 install_name_id  @rpath/libgrass_qtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_qtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_qtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_qtree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_gmath
 install_name_id  @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_display
 install_name_id  @rpath/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_pngdriver
 install_name_id  @rpath/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

  # libgrass_psdriver
 install_name_id  @rpath/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_htmldriver
 install_name_id  @rpath/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

  # libgrass_driver
 install_name_id  @rpath/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_htmldriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_driver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dgl
 install_name_id  @rpath/libgrass_dgl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dgl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dgl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dgl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dgl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dgl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_stats
 install_name_id  @rpath/libgrass_stats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dspf
 install_name_id  @rpath/libgrass_dspf.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dspf.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_imagery
 install_name_id  @rpath/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_sim
 install_name_id  @rpath/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_datetime
 install_name_id  @rpath/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_datetime.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_gmath
 install_name_id  @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_gmath.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_lrs
 install_name_id  @rpath/libgrass_lrs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_gpde
 install_name_id  @rpath/libgrass_gpde.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_g3d
 install_name_id  @rpath/libgrass_g3d.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_g3d.7.8.dylib @rpath/libgrass_g3d.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_g3d.7.8.dylib @rpath/libgrass_g3d.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_interpdata
 install_name_id  @rpath/libgrass_interpdata.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpdata.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_interpdata.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_interpdata.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_cdhc
 install_name_id  @rpath/libgrass_cdhc.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cdhc.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_btree
 install_name_id  @rpath/libgrass_btree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_btree.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_neta
 install_name_id  @rpath/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dbstubs
 install_name_id  @rpath/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_dbstubs.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_dbmidriver
 install_name_id  @rpath/libgrass_dbmidriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_shape
 install_name_id  @rpath/libgrass_shape.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_shape.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_psdriver
 install_name_id  @rpath/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_iortho
 install_name_id  @rpath/libgrass_iortho.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_bitmap
 install_name_id  @rpath/libgrass_bitmap.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_bitmap.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_bitmap.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_bitmap.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_linkm
 install_name_id  @rpath/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_linkm.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_bitmap.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_symb
 install_name_id  @rpath/libgrass_symb.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_symb.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_temporal
 install_name_id  @rpath/libgrass_temporal.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_vedit
 install_name_id  @rpath/libgrass_vedit.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_sqlp
 install_name_id  @rpath/libgrass_sqlp.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sqlp.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_segment
 install_name_id  @rpath/libgrass_segment.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_segment.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_segment.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/libgrass_segment.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_rli
 install_name_id  @rpath/libgrass_rli.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rli.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_interpfl
 install_name_id  @rpath/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 # libgrass_lidar
 install_name_id  @rpath/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

  install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libgeos_c @rpath/$LINK_libgeos_c $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
}
