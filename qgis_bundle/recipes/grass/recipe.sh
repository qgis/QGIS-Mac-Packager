#!/bin/bash

function check_grass() {
  env_var_exists VERSION_grass
  env_var_exists DEPS_GRASS_LIB_DIR
}

function bundle_grass() {
	try cp -av $DEPS_GRASS_LIB_DIR/libgrass_*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_grass() {
 for i in \
   libgrass_rtree \
   libgrass_manage \
   libgrass_dbstubs \
   libgrass_dig2 \
   libgrass_rowio \
   libgrass_gproj \
   libgrass_htmldriver \
   libgrass_btree \
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
   libgrass_interpdata \
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
   libgrass_dgl \
   libgrass_gis \
   libgrass_vedit \
   libgrass_temporal \
   libgrass_iortho \
   libgrass_dbmiclient \
   libgrass_symb \
   libgrass_psdriver \
   libgrass_dbmidriver \
   libgrass_neta \
   libgrass_raster \
   libgrass_shape \
   libgrass_bitmap \
   libgrass_linkm \
   libgrass_cdhc \
   libgrass_sqlp \
   libgrass_datetime \
   libgrass_ccmath \
   libgrass_qtree
  do
    install_name_id \
      @rpath/$i.${VERSION_grass_major}.${VERSION_grass_minor}.dylib \
      $BUNDLE_LIB_DIR/$i.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

     for j in \
      $LINK_gdal \
      $LINK_libgeos_c \
      $LINK_libpng \
      $LINK_zlib \
      $LINK_zstd \
      $LINK_libproj
    do
      install_name_change \
        $DEPS_LIB_DIR/$j \
        @rpath/$j \
        $BUNDLE_LIB_DIR/$i.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
    done

    for j in \
     libgrass_rtree \
     libgrass_manage \
     libgrass_dbstubs \
     libgrass_dig2 \
     libgrass_rowio \
     libgrass_gproj \
     libgrass_htmldriver \
     libgrass_btree \
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
     libgrass_interpdata \
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
     libgrass_dgl \
     libgrass_gis \
     libgrass_vedit \
     libgrass_temporal \
     libgrass_iortho \
     libgrass_dbmiclient \
     libgrass_symb \
     libgrass_psdriver \
     libgrass_dbmidriver \
     libgrass_neta \
     libgrass_raster \
     libgrass_shape \
     libgrass_bitmap \
     libgrass_linkm \
     libgrass_cdhc \
     libgrass_sqlp \
     libgrass_datetime \
     libgrass_ccmath \
     libgrass_qtree
    do
      install_name_change $DEPS_GRASS_LIB_DIR/$j.${VERSION_grass_major}.${VERSION_grass_minor}.dylib \
                          @rpath/$j.${VERSION_grass_major}.${VERSION_grass_minor}.dylib \
                          $BUNDLE_LIB_DIR/$i.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
    done
  done
}

function fix_binaries_grass_check() {
  verify_binary $BUNDLE_LIB_DIR/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
}

function fix_paths_grass() {
  :
}

function fix_paths_grass_check() {
  :
}
