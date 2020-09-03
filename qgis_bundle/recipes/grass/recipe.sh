#!/bin/bash

function check_grass() {
  env_var_exists VERSION_grass
  env_var_exists VERSION_grass_major
  env_var_exists VERSION_grass_minor
  env_var_exists DEPS_GRASS_LIB_DIR
}

function bundle_grass() {
  GRASS_BUNDLE_DIR=$BUNDLE_RESOURCES_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}

	try rsync -av \
     $DEPS_GRASS_ROOT_DIR/ \
     $GRASS_BUNDLE_DIR/ \
     --exclude include \
     --exclude gui \
     --exclude demolocation \
     --exclude __pycache__

  try cp -av $RECIPES_PATH/grass/grass.bash $GRASS_BUNDLE_DIR/grass
  try cp -av $DEPS_BIN_DIR/grass${VERSION_grass_major}${VERSION_grass_minor} $GRASS_BUNDLE_DIR/_grass

  # see python/plugins/processing/algs/grass7/Grass7Utils.py
  # the grass directory must be in Contents/MacOS directory
  mk_sym_link $BUNDLE_MACOS_DIR ../Resources/grass${VERSION_grass_major}${VERSION_grass_minor} grass${VERSION_grass_major}${VERSION_grass_minor}
}

function fix_rpaths_grass() {
  FNAME=$1

  for j in \
      $LINK_gdal \
      $LINK_libgeos_c \
      $LINK_libpng \
      $LINK_zlib \
      $LINK_zstd \
      $LINK_libproj \
      $LINK_sqlite \
      $LINK_netcdf
  do
      install_name_change \
        $DEPS_LIB_DIR/$j \
        @rpath/$j \
        $FNAME
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
                          $FNAME
    done

}

function fix_binaries_grass() {
 GRASS_BUNDLE_DIR=$BUNDLE_RESOURCES_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}
 export -f fix_rpaths_grass

 ######
 # LIBS
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
      $GRASS_BUNDLE_DIR/lib/$i.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

    sem -j+0 "fix_rpaths_grass $GRASS_BUNDLE_DIR/lib/$i.${VERSION_grass_major}.${VERSION_grass_minor}.dylib"
  done

  ######
  # BINS
  BINS=$(find $GRASS_BUNDLE_DIR/bin -type f)
  for i in $BINS; do
    install_name_add_rpath @executable_path/../lib $i
    sem -j+0 "fix_rpaths_grass $i"
  done

  ######
  # TOOLS
  fix_rpaths_grass $GRASS_BUNDLE_DIR/tools/g.echo
  install_name_add_rpath @executable_path/../lib $GRASS_BUNDLE_DIR/tools/g.echo

  ######
  # DRIVERS
  DRIVERS=$(find $GRASS_BUNDLE_DIR/driver/db -type f)
  for i in $DRIVERS; do
    sem -j+0 "fix_rpaths_grass $i"
  done

  ######
  # ETC
  for i in \
    clean_temp \
    r.watershed/seg \
    r.watershed/ram \
    lock \
    lister/cell \
    lister/vector \
    i.find
  do
    install_name_add_rpath @executable_path/../lib $GRASS_BUNDLE_DIR/etc/$i
    sem -j+0 "fix_rpaths_grass $GRASS_BUNDLE_DIR/etc/$i"
  done

  ### DONE
  sem --wait

  ### now clean leftovers
  clean_binary $GRASS_BUNDLE_DIR/bin/g.mkfontcap
  clean_binary $GRASS_BUNDLE_DIR/bin/r.terraflow matches
  clean_binary $GRASS_BUNDLE_DIR/bin/r.viewshed matches
  clean_binary $GRASS_BUNDLE_DIR/bin/g.version matches

  # not sure what to do with these?
  try ${SED} "s;$DEPS_GRASS_ROOT_DIR;..;g" $GRASS_BUNDLE_DIR/etc/fontcap

}

function fix_binaries_grass_check() {
  GRASS_BUNDLE_DIR=$BUNDLE_RESOURCES_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}

  verify_binary $GRASS_BUNDLE_DIR/lib/libgrass_raster.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
  verify_binary $GRASS_BUNDLE_DIR/bin/d.barscale
  verify_binary $GRASS_BUNDLE_DIR/tools/g.echo
  verify_binary $GRASS_BUNDLE_DIR/driver/db/ogr
  verify_binary $GRASS_BUNDLE_DIR/bin/r3.out.netcdf
}

function fix_paths_grass() {
  GRASS_BUNDLE_DIR=$BUNDLE_RESOURCES_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}

  clean_path $GRASS_BUNDLE_DIR/_grass

  GENERATED_FILES=$(find $GRASS_BUNDLE_DIR/etc/python/grass/lib/*.py)
  for i in $GENERATED_FILES
  do
    clean_path $i
  done

}

function fix_paths_grass_check() {
  GRASS_BUNDLE_DIR=$BUNDLE_RESOURCES_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}

  verify_file_paths $GRASS_BUNDLE_DIR/grass
  verify_file_paths $GRASS_BUNDLE_DIR/_grass
  verify_file_paths $GRASS_BUNDLE_DIR/scripts/d.shade
}
