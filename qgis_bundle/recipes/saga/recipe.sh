#!/bin/bash

function check_saga() {
  env_var_exists VERSION_saga
}

function bundle_saga() {
  try mkdir -p $BUNDLE_RESOURCES_DIR/saga/toolchains
  try rsync -av $DEPS_SHARE_DIR/saga/toolchains/ $BUNDLE_RESOURCES_DIR/saga/toolchains/

  try rsync -av $DEPS_LIB_DIR/saga/ $BUNDLE_LIB_DIR/saga/ --exclude=*.la --exclude=*.a
  try cp -av $DEPS_LIB_DIR/libsaga_api*dylib $BUNDLE_LIB_DIR/
  
  try cp -av $DEPS_BIN_DIR/saga_cmd $BUNDLE_BIN_DIR/
}

function postbundle_saga() {
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/bin/saga_cmd
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_segmentation.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgarden_games.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgarden_fractals.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_landscape_evolution.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_cellular_automata.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_profiles.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_visualisation.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_preprocessor.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libtable_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_analysis.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_ihacres.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_filter.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libstatistics_grid.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_grid.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpj_georeference.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_calculus.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_erosion.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_gps.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_lines.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_gdal.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_rivflow.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpj_proj4.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libdb_pgsql.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libtin_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libdocs_html.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libtable_calculus.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_classification.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgarden_learn_to_program.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes_dxf.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_hydrology.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libcontrib_perego.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_ecosystems_hugget.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_slope_stability.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_maxent.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_polygons.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrids_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libstatistics_regression.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libclimate_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_transect.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_svm.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libstatistics_points.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_grid.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_compound.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_photogrammetry.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_geomorphology.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_qm_of_esp.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_lighting.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_spline.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_esri_e00.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_morphometry.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_calculus_bsl.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_hydrology.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_table.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_channels.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_gridding.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libsaga_api-7.3.0.dylib @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_points.dylib

  install_name_id @rpath/libsaga_api-7.3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libsaga_api-7.3.0.dylib
  install_name_id @rpath/libclimate_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libclimate_tools.dylib
  install_name_id @rpath/libcontrib_perego.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libcontrib_perego.dylib
  install_name_id @rpath/libdb_pgsql.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libdb_pgsql.dylib
  install_name_id @rpath/libdocs_html.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libdocs_html.dylib
  install_name_id @rpath/libgarden_fractals.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgarden_fractals.dylib
  install_name_id @rpath/libgarden_games.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgarden_games.dylib
  install_name_id @rpath/libgarden_learn_to_program.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgarden_learn_to_program.dylib
  install_name_id @rpath/libgrid_analysis.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_analysis.dylib
  install_name_id @rpath/libgrid_calculus.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_calculus.dylib
  install_name_id @rpath/libgrid_calculus_bsl.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_calculus_bsl.dylib
  install_name_id @rpath/libgrid_filter.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_filter.dylib
  install_name_id @rpath/libgrid_gridding.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_gridding.dylib
  install_name_id @rpath/libgrid_spline.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_spline.dylib
  install_name_id @rpath/libgrid_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_tools.dylib
  install_name_id @rpath/libgrid_visualisation.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrid_visualisation.dylib
  install_name_id @rpath/libgrids_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libgrids_tools.dylib
  install_name_id @rpath/libimagery_classification.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_classification.dylib
  install_name_id @rpath/libimagery_maxent.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_maxent.dylib
  install_name_id @rpath/libimagery_photogrammetry.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_photogrammetry.dylib
  install_name_id @rpath/libimagery_segmentation.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_segmentation.dylib
  install_name_id @rpath/libimagery_svm.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_svm.dylib
  install_name_id @rpath/libimagery_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libimagery_tools.dylib
  install_name_id @rpath/libio_esri_e00.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_esri_e00.dylib
  install_name_id @rpath/libio_gdal.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_gdal.dylib
  install_name_id @rpath/libio_gps.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_gps.dylib
  install_name_id @rpath/libio_grid.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_grid.dylib
  install_name_id @rpath/libio_shapes.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
  install_name_id @rpath/libio_shapes_dxf.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes_dxf.dylib
  install_name_id @rpath/libio_table.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_table.dylib
  install_name_id @rpath/libio_virtual.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
  install_name_id @rpath/libpj_georeference.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpj_georeference.dylib
  install_name_id @rpath/libpj_proj4.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpj_proj4.dylib
  install_name_id @rpath/libpointcloud_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
  install_name_id @rpath/libshapes_grid.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_grid.dylib
  install_name_id @rpath/libshapes_lines.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_lines.dylib
  install_name_id @rpath/libshapes_points.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_points.dylib
  install_name_id @rpath/libshapes_polygons.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_polygons.dylib
  install_name_id @rpath/libshapes_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_tools.dylib
  install_name_id @rpath/libshapes_transect.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libshapes_transect.dylib
  install_name_id @rpath/libsim_cellular_automata.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_cellular_automata.dylib
  install_name_id @rpath/libsim_ecosystems_hugget.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_ecosystems_hugget.dylib
  install_name_id @rpath/libsim_erosion.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_erosion.dylib
  install_name_id @rpath/libsim_geomorphology.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_geomorphology.dylib
  install_name_id @rpath/libsim_hydrology.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_hydrology.dylib
  install_name_id @rpath/libsim_ihacres.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_ihacres.dylib
  install_name_id @rpath/libsim_landscape_evolution.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_landscape_evolution.dylib
  install_name_id @rpath/libsim_qm_of_esp.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_qm_of_esp.dylib
  install_name_id @rpath/libsim_rivflow.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libsim_rivflow.dylib
  install_name_id @rpath/libstatistics_grid.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libstatistics_grid.dylib
  install_name_id @rpath/libstatistics_points.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libstatistics_points.dylib
  install_name_id @rpath/libstatistics_regression.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libstatistics_regression.dylib
  install_name_id @rpath/libta_channels.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_channels.dylib
  install_name_id @rpath/libta_compound.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_compound.dylib
  install_name_id @rpath/libta_hydrology.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_hydrology.dylib
  install_name_id @rpath/libta_lighting.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_lighting.dylib
  install_name_id @rpath/libta_morphometry.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_morphometry.dylib
  install_name_id @rpath/libta_preprocessor.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_preprocessor.dylib
  install_name_id @rpath/libta_profiles.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_profiles.dylib
  install_name_id @rpath/libta_slope_stability.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libta_slope_stability.dylib
  install_name_id @rpath/libtable_calculus.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libtable_calculus.dylib
  install_name_id @rpath/libtable_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libtable_tools.dylib
  install_name_id @rpath/libtin_tools.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libtin_tools.dylib

}

function add_config_info_saga() {
    :
}
