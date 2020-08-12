#!/bin/bash

function check_grass() {
  env_var_exists VERSION_grass
  env_var_exists DEPS_GRASS_LIB_DIR
}

function bundle_grass() {
	try cp -av $DEPS_GRASS_LIB_DIR/libgrass_*dylib $BUNDLE_LIB_DIR
}

function postbundle_grass() {
 GDYLIB=.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
  
 # libgrass_gis
 install_name_id  @rpath/libgrass_gis.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_gis.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/libgrass_gis.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_zstd @rpath/$LINK_zstd $BUNDLE_LIB_DIR/libgrass_gis.${GDYLIB}

 for i in \
   libgrass_rtree \
   libgrass_manage \
   libgrass_dbstubs \
   libgrass_dig2 \
   libgrass_rowio \
   libgrass_gproj \
   libgrass_htmldriver \
   libgrass_btree2 \
   libgrass_display \
   libgrass_gmath \
   libgrass_vector \
   libgrass_dbmibase \
   libgrass_cluster \
   libgrass_arraystats \
   libgrass_calc \
   libgrass_stats \
   libgrass_rli \
   libgrass_interpfl \
   libgrass_pngdriver \
   libgrass_dspf \
   libgrass_imagery \
   libgrass_sim \
   libgrass_lrs \
   libgrass_gpde \
   libgrass_lidar \
   libgrass_driver \
   libgrass_g3d \
   libgrass_segment \
   libgrass_gis \
   libgrass_vedit \
   libgrass_temporal \
   libgrass_iortho \
   libgrass_dbmiclient \
   libgrass_symb \
   libgrass_psdriver \
   libgrass_dbmidriver \
   libgrass_neta \
   libgrass_raster
  do
    install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gis.${GDYLIB} \
                        @rpath/libgrass_gis.${GDYLIB} \
                        $BUNDLE_LIB_DIR/$i.${GDYLIB}
  done

 # libgrass_vector
 install_name_id  @rpath/libgrass_vector.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_vector.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_LIB_DIR/libgrass_vector.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_libgeos_c @rpath/$LINK_libgeos_c $BUNDLE_LIB_DIR/libgrass_vector.${GDYLIB}

 for i in \
   libgrass_manage \
   libgrass_vector \
   libgrass_interpfl \
   libgrass_imagery \
   libgrass_sim \
   libgrass_lidar \
   libgrass_vedit \
   libgrass_neta
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_vector.${GDYLIB} \
                       @rpath/libgrass_vector.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_raster
 install_name_id  @rpath/libgrass_raster.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_raster.${GDYLIB}

 for i in \
   libgrass_display \
   libgrass_vector \
   libgrass_cluster \
   libgrass_calc \
   libgrass_stats \
   libgrass_rli \
   libgrass_interpfl \
   libgrass_imagery \
   libgrass_sim \
   libgrass_gpde \
   libgrass_lidar \
   libgrass_g3d \
   libgrass_raster
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_raster.${GDYLIB} \
                       @rpath/libgrass_raster.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_imagery
 install_name_id  @rpath/libgrass_imagery.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_imagery.${GDYLIB}

 for i in \
   libgrass_cluster \
   libgrass_imagery \
   libgrass_iortho
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_imagery.${GDYLIB} \
                       @rpath/libgrass_imagery.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_dbmibase
 install_name_id  @rpath/libgrass_dbmibase.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dbmibase.${GDYLIB}

 for i in \
   libgrass_dbstubs \
   libgrass_vector \
   libgrass_dbmibase \
   libgrass_interpfl \
   libgrass_lrs \
   libgrass_lidar \
   libgrass_vedit \
   libgrass_temporal \
   libgrass_dbmiclient \
   libgrass_dbmidriver \
   libgrass_neta
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmibase.${GDYLIB} \
                       @rpath/libgrass_dbmibase.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_dbmiclient
 install_name_id  @rpath/libgrass_dbmiclient.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dbmiclient.${GDYLIB}

 for i in \
   libgrass_vector \
   libgrass_interpfl \
   libgrass_lrs \
   libgrass_lidar \
   libgrass_vedit \
   libgrass_temporal \
   libgrass_dbmiclient \
   libgrass_neta
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbmiclient.${GDYLIB} \
                       @rpath/libgrass_dbmiclient.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_gproj
 install_name_id  @rpath/libgrass_gproj.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_gproj.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_LIB_DIR/libgrass_gproj.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_LIB_DIR/libgrass_gproj.${GDYLIB}

 for i in \
   libgrass_gproj \
   libgrass_vector \
   libgrass_raster
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gproj.${GDYLIB} \
                       @rpath/libgrass_gproj.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_rtree
 install_name_id  @rpath/libgrass_rtree.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_rtree.${GDYLIB}

 for i in \
   libgrass_rtree \
   libgrass_dig2 \
   libgrass_vector
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_rtree.${GDYLIB} \
                       @rpath/libgrass_rtree.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_linkm
 install_name_id  @rpath/libgrass_linkm.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_linkm.${GDYLIB}
 
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_linkm.${GDYLIB} \
                     @rpath/libgrass_linkm.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_linkm.${GDYLIB}

 # libgrass_manage
 install_name_id  @rpath/libgrass_manage.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_manage.${GDYLIB}

 # libgrass_cluster
 install_name_id  @rpath/libgrass_cluster.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_cluster.${GDYLIB}

 # libgrass_arraystats
 install_name_id  @rpath/libgrass_arraystats.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_arraystats.${GDYLIB}

 # libgrass_stats
 install_name_id  @rpath/libgrass_stats.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_stats.${GDYLIB}

 # libgrass_calc
 install_name_id  @rpath/libgrass_calc.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_calc.${GDYLIB}

 # libgrass_dbstubs
 install_name_id  @rpath/libgrass_dbstubs.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dbstubs.${GDYLIB}

 # libgrass_dig2
 install_name_id  @rpath/libgrass_dig2.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dig2.${GDYLIB}
 
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dig2.${GDYLIB} \
                     @rpath/libgrass_dig2.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_vector.${GDYLIB}

 # libgrass_ccmath
 install_name_id  @rpath/libgrass_ccmath.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_ccmath.${GDYLIB}
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_ccmath.${GDYLIB} \
                     @rpath/libgrass_ccmath.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_gmath.${GDYLIB}

 # libgrass_rowio
 install_name_id  @rpath/libgrass_rowio.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_rowio.${GDYLIB}

 # libgrass_btree2
 install_name_id  @rpath/libgrass_btree2.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_btree2.${GDYLIB}

 for i in \
   libgrass_rtree \
   libgrass_dig2 \
   libgrass_vector
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_rtree.${GDYLIB} \
                       @rpath/libgrass_rtree.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done
 
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_btree2.${GDYLIB} @rpath/libgrass_btree2.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_vector.${GDYLIB}
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_btree2.${GDYLIB} @rpath/libgrass_btree2.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_segment.${GDYLIB}

 # libgrass_qtree
 install_name_id  @rpath/libgrass_qtree.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_qtree.${GDYLIB}
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_qtree.${GDYLIB} @rpath/libgrass_qtree.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_interpfl.${GDYLIB}

 # libgrass_gmath
 install_name_id  @rpath/libgrass_gmath.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_gmath.${GDYLIB}

 # libgrass_display
 install_name_id  @rpath/libgrass_display.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_display.${GDYLIB}
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_htmldriver.${GDYLIB} \
                     @rpath/libgrass_htmldriver.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_display.${GDYLIB}

 # libgrass_pngdriver
 install_name_id  @rpath/libgrass_pngdriver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_pngdriver.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_LIB_DIR/libgrass_pngdriver.${GDYLIB}
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/libgrass_pngdriver.${GDYLIB}

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_pngdriver.${GDYLIB} \
                     @rpath/libgrass_pngdriver.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_display.${GDYLIB}


 # libgrass_psdriver
 install_name_id  @rpath/libgrass_psdriver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_psdriver.${GDYLIB}
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_psdriver.${GDYLIB} \
                     @rpath/libgrass_psdriver.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_display.${GDYLIB}

 # libgrass_htmldriver
 install_name_id  @rpath/libgrass_htmldriver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_htmldriver.${GDYLIB}
 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_htmldriver.${GDYLIB} @rpath/libgrass_htmldriver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_display.${GDYLIB}

  # libgrass_driver
 install_name_id  @rpath/libgrass_driver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_driver.${GDYLIB}

 for i in \
   libgrass_htmldriver \
   libgrass_display \
   libgrass_pngdriver \
   libgrass_psdriver
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_driver.${GDYLIB} \
                       @rpath/libgrass_driver.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_dgl
 install_name_id  @rpath/libgrass_dgl.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dgl.${GDYLIB}

 for i in \
   libgrass_vector \
   libgrass_neta
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dgl.${GDYLIB} \
                       @rpath/libgrass_dgl.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_stats
 install_name_id  @rpath/libgrass_stats.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_stats.${GDYLIB}

 # libgrass_dspf
 install_name_id  @rpath/libgrass_dspf.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dspf.${GDYLIB}

 # libgrass_imagery
 install_name_id  @rpath/libgrass_imagery.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_imagery.${GDYLIB}

 # libgrass_sim
 install_name_id  @rpath/libgrass_sim.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_sim.${GDYLIB}

 # libgrass_datetime
 install_name_id  @rpath/libgrass_datetime.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_datetime.${GDYLIB}

 for i in \
   libgrass_sim \
   libgrass_gis \
   libgrass_temporal
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_datetime.${GDYLIB} \
                       @rpath/libgrass_datetime.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_gmath
 install_name_id  @rpath/libgrass_gmath.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_gmath.${GDYLIB}

 for i in \
   libgrass_interpfl \
   libgrass_sim \
   libgrass_gpde \
   libgrass_lidar \
   libgrass_iortho
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_gmath.${GDYLIB} \
                       @rpath/libgrass_gmath.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_lrs
 install_name_id  @rpath/libgrass_lrs.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_lrs.${GDYLIB}

 # libgrass_gpde
 install_name_id  @rpath/libgrass_gpde.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_gpde.${GDYLIB}

 # libgrass_g3d
 install_name_id  @rpath/libgrass_g3d.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_g3d.${GDYLIB}

 for i in \
   libgrass_gpde \
   libgrass_g3d
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_g3d.${GDYLIB} \
                       @rpath/libgrass_g3d.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_interpdata
 install_name_id  @rpath/libgrass_interpdata.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_interpdata.${GDYLIB}

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_interpdata.${GDYLIB} \
                     @rpath/libgrass_interpdata.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_interpfl.${GDYLIB}

 # libgrass_cdhc
 install_name_id  @rpath/libgrass_cdhc.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_cdhc.${GDYLIB}

 # libgrass_btree
 install_name_id  @rpath/libgrass_btree.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_btree.${GDYLIB}

 # libgrass_neta
 install_name_id  @rpath/libgrass_neta.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_neta.${GDYLIB}

 # libgrass_dbstubs
 install_name_id  @rpath/libgrass_dbstubs.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dbstubs.${GDYLIB}

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_dbstubs.${GDYLIB} \
                     @rpath/libgrass_dbstubs.${GDYLIB}
                     $BUNDLE_LIB_DIR/libgrass_dbmidriver.${GDYLIB}

 # libgrass_dbmidriver
 install_name_id  @rpath/libgrass_dbmidriver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_dbmidriver.${GDYLIB}

 # libgrass_shape
 install_name_id  @rpath/libgrass_shape.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_shape.${GDYLIB}

 # libgrass_psdriver
 install_name_id  @rpath/libgrass_psdriver.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_psdriver.${GDYLIB}

 # libgrass_iortho
 install_name_id  @rpath/libgrass_iortho.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_iortho.${GDYLIB}

 # libgrass_bitmap
 install_name_id  @rpath/libgrass_bitmap.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_bitmap.${GDYLIB}

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_bitmap.${GDYLIB} \
                     @rpath/libgrass_bitmap.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_interpfl.${GDYLIB}

 # libgrass_linkm
 install_name_id  @rpath/libgrass_linkm.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_linkm.${GDYLIB}

 for i in \
   libgrass_vector \
   libgrass_bitmap
 do
   install_name_change $DEPS_GRASS_LIB_DIR/libgrass_linkm.${GDYLIB} \
                       @rpath/libgrass_linkm.${GDYLIB} \
                       $BUNDLE_LIB_DIR/$i.${GDYLIB}
 done

 # libgrass_symb
 install_name_id  @rpath/libgrass_symb.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_symb.${GDYLIB}

 # libgrass_temporal
 install_name_id  @rpath/libgrass_temporal.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_temporal.${GDYLIB}

 # libgrass_vedit
 install_name_id  @rpath/libgrass_vedit.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_vedit.${GDYLIB}

 # libgrass_sqlp
 install_name_id  @rpath/libgrass_sqlp.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_sqlp.${GDYLIB}

 # libgrass_segment
 install_name_id  @rpath/libgrass_segment.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_segment.${GDYLIB}

 install_name_change $DEPS_GRASS_LIB_DIR/libgrass_segment.${GDYLIB} \
                     @rpath/libgrass_segment.${GDYLIB} \
                     $BUNDLE_LIB_DIR/libgrass_lidar.${GDYLIB}

 # libgrass_rli
 install_name_id  @rpath/libgrass_rli.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_rli.${GDYLIB}

 # libgrass_interpfl
 install_name_id  @rpath/libgrass_interpfl.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_interpfl.${GDYLIB}

 # libgrass_lidar
 install_name_id  @rpath/libgrass_lidar.${GDYLIB} $BUNDLE_LIB_DIR/libgrass_lidar.${GDYLIB}
}
