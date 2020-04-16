#!/bin/bash

GRASS_ROOT_DIR=$DEPS_ROOT_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}/
GRASS_LIB_DIR=$GRASS_ROOT_DIR/lib
GRASS_LINK_VERSION=${VERSION_grass_major}.${VERSION_grass_minor}

function check_grass() {
  env_var_exists VERSION_grass
}

function bundle_grass() {
	try cp -av $GRASS_LIB_DIR/libgrass_*dylib $BUNDLE_LIB_DIR
}

function postbundle_grass() {
 # libgrass_gis
 install_name_id  @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rtree.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_manage.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dig2.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rowio.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_htmldriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_btree2.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmibase.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_arraystats.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_calc.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rli.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dspf.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_driver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_segment.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_symb.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gis.7.8.dylib @rpath/libgrass_gis.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.7.8.dylib

 # libgrass_vector
 install_name_id  @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_manage.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_vector.7.8.dylib @rpath/libgrass_vector.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.7.8.dylib

 # libgrass_raster
 install_name_id  @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_calc.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rli.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_raster.7.8.dylib @rpath/libgrass_raster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.7.8.dylib

 # libgrass_imagery
 install_name_id  @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_imagery.7.8.dylib @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.7.8.dylib

 # libgrass_dbmibase
 install_name_id  @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmibase.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmibase.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmibase.7.8.dylib @rpath/libgrass_dbmibase.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.7.8.dylib

 # libgrass_dbmiclient
 install_name_id  @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmiclient.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbmiclient.7.8.dylib @rpath/libgrass_dbmiclient.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.7.8.dylib

 # libgrass_gproj
 install_name_id  @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass7.framework/Versions/3.13/qgisgrass7
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gproj.7.8.dylib @rpath/libgrass_gproj.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_raster.7.8.dylib

 # libgrass_rtree
 install_name_id  @rpath/libgrass_rtree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rtree.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_rtree.7.8.dylib @rpath/libgrass_rtree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rtree.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_rtree.7.8.dylib @rpath/libgrass_rtree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dig2.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_rtree.7.8.dylib @rpath/libgrass_rtree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib

 # libgrass_linkm
 install_name_id  @rpath/libgrass_linkm.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_linkm.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_linkm.7.8.dylib @rpath/libgrass_linkm.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_linkm.7.8.dylib

 # libgrass_manage
 install_name_id  @rpath/libgrass_manage.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_manage.7.8.dylib

 # libgrass_cluster
 install_name_id  @rpath/libgrass_cluster.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cluster.7.8.dylib

 # libgrass_arraystats
 install_name_id  @rpath/libgrass_arraystats.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_arraystats.7.8.dylib

 # libgrass_stats
 install_name_id  @rpath/libgrass_stats.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.7.8.dylib

 # libgrass_calc
 install_name_id  @rpath/libgrass_calc.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_calc.7.8.dylib

 # libgrass_dbstubs
 install_name_id  @rpath/libgrass_dbstubs.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.7.8.dylib

  # libgrass_dig2
 install_name_id  @rpath/libgrass_dig2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dig2.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dig2.7.8.dylib @rpath/libgrass_dig2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib

 # libgrass_ccmath
 install_name_id  @rpath/libgrass_ccmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_ccmath.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_ccmath.7.8.dylib @rpath/libgrass_ccmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.7.8.dylib

 # libgrass_rowio
 install_name_id  @rpath/libgrass_rowio.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rowio.7.8.dylib

 # libgrass_btree2
 install_name_id  @rpath/libgrass_btree2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_btree2.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_btree2.7.8.dylib @rpath/libgrass_btree2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_btree2.7.8.dylib @rpath/libgrass_btree2.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_segment.7.8.dylib

 # libgrass_qtree
 install_name_id  @rpath/libgrass_qtree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_qtree.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_qtree.7.8.dylib @rpath/libgrass_qtree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib

 # libgrass_gmath
 install_name_id  @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.7.8.dylib

 # libgrass_display
 install_name_id  @rpath/libgrass_display.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_htmldriver.7.8.dylib @rpath/libgrass_htmldriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib

 # libgrass_pngdriver
 install_name_id  @rpath/libgrass_pngdriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_pngdriver.7.8.dylib @rpath/libgrass_pngdriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib

  # libgrass_psdriver
 install_name_id  @rpath/libgrass_psdriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_psdriver.7.8.dylib @rpath/libgrass_psdriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib

 # libgrass_htmldriver
 install_name_id  @rpath/libgrass_htmldriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_htmldriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_htmldriver.7.8.dylib @rpath/libgrass_htmldriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib

  # libgrass_driver
 install_name_id  @rpath/libgrass_driver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_driver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_driver.7.8.dylib @rpath/libgrass_driver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_htmldriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_driver.7.8.dylib @rpath/libgrass_driver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_display.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_driver.7.8.dylib @rpath/libgrass_driver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_driver.7.8.dylib @rpath/libgrass_driver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.7.8.dylib

 # libgrass_dgl
 install_name_id  @rpath/libgrass_dgl.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dgl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dgl.7.8.dylib @rpath/libgrass_dgl.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dgl.7.8.dylib @rpath/libgrass_dgl.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.7.8.dylib

 # libgrass_stats
 install_name_id  @rpath/libgrass_stats.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_stats.7.8.dylib

 # libgrass_dspf
 install_name_id  @rpath/libgrass_dspf.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dspf.7.8.dylib

 # libgrass_imagery
 install_name_id  @rpath/libgrass_imagery.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_imagery.7.8.dylib

 # libgrass_sim
 install_name_id  @rpath/libgrass_sim.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.7.8.dylib

 # libgrass_datetime
 install_name_id  @rpath/libgrass_datetime.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_datetime.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_datetime.7.8.dylib @rpath/libgrass_datetime.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_datetime.7.8.dylib @rpath/libgrass_datetime.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_datetime.7.8.dylib @rpath/libgrass_datetime.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.7.8.dylib

 # libgrass_gmath
 install_name_id  @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gmath.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gmath.7.8.dylib @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gmath.7.8.dylib @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sim.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gmath.7.8.dylib @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gmath.7.8.dylib @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_gmath.7.8.dylib @rpath/libgrass_gmath.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.7.8.dylib

 # libgrass_lrs
 install_name_id  @rpath/libgrass_lrs.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lrs.7.8.dylib

 # libgrass_gpde
 install_name_id  @rpath/libgrass_gpde.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.7.8.dylib

 # libgrass_g3d
 install_name_id  @rpath/libgrass_g3d.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_g3d.7.8.dylib @rpath/libgrass_g3d.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gpde.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_g3d.7.8.dylib @rpath/libgrass_g3d.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_g3d.7.8.dylib

 # libgrass_interpdata
 install_name_id  @rpath/libgrass_interpdata.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpdata.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_interpdata.7.8.dylib @rpath/libgrass_interpdata.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib

 # libgrass_cdhc
 install_name_id  @rpath/libgrass_cdhc.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_cdhc.7.8.dylib

 # libgrass_btree
 install_name_id  @rpath/libgrass_btree.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_btree.7.8.dylib

 # libgrass_neta
 install_name_id  @rpath/libgrass_neta.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_neta.7.8.dylib

 # libgrass_dbstubs
 install_name_id  @rpath/libgrass_dbstubs.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbstubs.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_dbstubs.7.8.dylib @rpath/libgrass_dbstubs.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.7.8.dylib

 # libgrass_dbmidriver
 install_name_id  @rpath/libgrass_dbmidriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_dbmidriver.7.8.dylib

 # libgrass_shape
 install_name_id  @rpath/libgrass_shape.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_shape.7.8.dylib

 # libgrass_psdriver
 install_name_id  @rpath/libgrass_psdriver.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_psdriver.7.8.dylib

 # libgrass_iortho
 install_name_id  @rpath/libgrass_iortho.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_iortho.7.8.dylib

 # libgrass_bitmap
 install_name_id  @rpath/libgrass_bitmap.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_bitmap.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_bitmap.7.8.dylib @rpath/libgrass_bitmap.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib

 # libgrass_linkm
 install_name_id  @rpath/libgrass_linkm.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_linkm.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_linkm.7.8.dylib @rpath/libgrass_linkm.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_linkm.7.8.dylib @rpath/libgrass_linkm.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_bitmap.7.8.dylib

 # libgrass_symb
 install_name_id  @rpath/libgrass_symb.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_symb.7.8.dylib

 # libgrass_temporal
 install_name_id  @rpath/libgrass_temporal.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_temporal.7.8.dylib

 # libgrass_vedit
 install_name_id  @rpath/libgrass_vedit.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vedit.7.8.dylib

 # libgrass_sqlp
 install_name_id  @rpath/libgrass_sqlp.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_sqlp.7.8.dylib

 # libgrass_segment
 install_name_id  @rpath/libgrass_segment.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_segment.7.8.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/grass78/lib/libgrass_segment.7.8.dylib @rpath/libgrass_segment.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib

 # libgrass_rli
 install_name_id  @rpath/libgrass_rli.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_rli.7.8.dylib

 # libgrass_interpfl
 install_name_id  @rpath/libgrass_interpfl.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_interpfl.7.8.dylib

 # libgrass_lidar
 install_name_id  @rpath/libgrass_lidar.7.8.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_lidar.7.8.dylib
}

function add_config_info_grass() {
    :
}
