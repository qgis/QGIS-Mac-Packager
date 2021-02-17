#!/bin/bash

function check_saga() {
  env_var_exists VERSION_saga
}

function bundle_saga() {
  try mkdir -p $BUNDLE_RESOURCES_DIR/saga/toolchains
  try rsync -av $DEPS_SHARE_DIR/saga/toolchains/ $BUNDLE_RESOURCES_DIR/saga/toolchains/

  try rsync -av $DEPS_LIB_DIR/saga/ $BUNDLE_LIB_DIR/saga/ --exclude=*.la --exclude=*.a
  try cp -av $DEPS_LIB_DIR/libsaga_api*dylib $BUNDLE_LIB_DIR/

  SAGA_RECIPE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  try cp -av $SAGA_RECIPE_DIR/saga_cmd $BUNDLE_BIN_DIR/
  chmod +x $BUNDLE_BIN_DIR/saga_cmd
  try cp -av $DEPS_BIN_DIR/saga_cmd $BUNDLE_BIN_DIR/_saga_cmd
}

function fix_binaries_saga() {
  install_name_change $DEPS_LIB_DIR/libsaga_api-$VERSION_saga.dylib @rpath/libsaga_api-$VERSION_saga.dylib $BUNDLE_CONTENTS_DIR/MacOS/bin/_saga_cmd
  install_name_id @rpath/libsaga_api-$VERSION_saga.dylib $BUNDLE_LIB_DIR/libsaga_api-$VERSION_saga.dylib
  install_name_add_rpath @executable_path/../lib $BUNDLE_BIN_DIR/_saga_cmd
  
  for i in \
    libimagery_segmentation \
    libgarden_games \
    libgarden_fractals   \
    libsim_landscape_evolution   \
    libsim_cellular_automata   \
    libta_profiles   \
    libgrid_visualisation   \
    libta_preprocessor   \
    libtable_tools   \
    libgrid_analysis   \
    libpointcloud_tools   \
    libsim_ihacres   \
    libgrid_filter   \
    libstatistics_grid   \
    libimagery_tools   \
    libshapes_grid   \
    libpj_georeference   \
    libgrid_calculus   \
    libsim_erosion   \
    libio_gps   \
    libshapes_lines   \
    libio_gdal   \
    libsim_rivflow   \
    libpj_proj4   \
    libdb_pgsql   \
    libtin_tools   \
    libgrid_tools   \
    libdocs_html   \
    libtable_calculus   \
    libimagery_classification   \
    libgarden_learn_to_program   \
    libio_shapes_dxf   \
    libta_hydrology   \
    libcontrib_perego   \
    libsim_ecosystems_hugget   \
    libta_slope_stability   \
    libimagery_maxent   \
    libshapes_polygons   \
    libgrids_tools   \
    libstatistics_regression   \
    libclimate_tools   \
    libshapes_transect   \
    libimagery_svm   \
    libio_shapes   \
    libstatistics_points   \
    libio_grid   \
    libta_compound   \
    libimagery_photogrammetry   \
    libsim_geomorphology   \
    libsim_qm_of_esp   \
    libta_lighting   \
    libgrid_spline   \
    libio_virtual   \
    libio_esri_e00   \
    libta_morphometry   \
    libgrid_calculus_bsl   \
    libsim_hydrology   \
    libio_table   \
    libta_channels   \
    libshapes_tools   \
    libgrid_gridding   \
    libshapes_points
  do
    install_name_id @rpath/saga/$i.dylib $BUNDLE_LIB_DIR/saga/$i.dylib
    install_name_change $DEPS_LIB_DIR/libsaga_api-$VERSION_saga.dylib @rpath/libsaga_api-$VERSION_saga.dylib $BUNDLE_LIB_DIR/saga/$i.dylib
  done

  install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_LIB_DIR/saga/libio_gdal.dylib
  install_name_change $DEPS_LIB_DIR/$LINK_libpq @rpath/$LINK_libpq $BUNDLE_LIB_DIR/saga/libdb_pgsql.dylib
  install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_LIB_DIR/saga/libpj_proj4.dylib

  for i in \
    lib/saga/libpointcloud_tools.dylib \
    lib/saga/libio_shapes.dylib \
    lib/saga/libio_virtual.dylib \
    lib/libsaga_api-$VERSION_saga.dylib \
    bin/_saga_cmd
  do
    install_name_change $DEPS_LIB_DIR/libwx_baseu-${VERSION_wxmac_major}.dylib @rpath/libwx_baseu-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
    install_name_change $DEPS_LIB_DIR/libwx_baseu_net-${VERSION_wxmac_major}.dylib @rpath/libwx_baseu_net-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
    install_name_change $DEPS_LIB_DIR/libwx_baseu_xml-${VERSION_wxmac_major}.dylib @rpath/libwx_baseu_xml-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
    install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_html-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_html-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
  done

  for i in \
    lib/saga/libpointcloud_tools.dylib \
    lib/saga/libio_shapes.dylib \
    lib/saga/libio_virtual.dylib
  do
    install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_adv-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
    install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_core-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
    install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_xrc-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_xrc-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
    install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_qa-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_qa-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/$i
  done
}

function fix_binaries_saga_check() {
  verify_binary $BUNDLE_LIB_DIR/saga/libio_gdal.dylib
  verify_binary $BUNDLE_BIN_DIR/_saga_cmd
}

function fix_paths_saga() {
  clean_binary $BUNDLE_BIN_DIR/_saga_cmd
}

function fix_paths_saga_check() {
  verify_file_paths $BUNDLE_BIN_DIR/_saga_cmd
}