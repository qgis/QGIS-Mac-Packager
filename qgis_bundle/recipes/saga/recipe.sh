#!/bin/bash

function check_saga() {
  env_var_exists VERSION_saga
}

function bundle_saga() {
    : # install_name_tool -id "@rpath/libsaga.dylib" ${STAGE_PATH}/lib/libsaga.dylib
}

function postbundle_saga() {
    :
}

function add_config_info_saga() {
    :
}

patch_saga_linker_links () {
  install_name_tool -id "@rpath/libsaga_api.dylib" ${STAGE_PATH}/lib/libsaga_api.dylib

  if [ ! -f "${STAGE_PATH}/lib/libsaga_api.${LINK_saga_version}.dylib" ]; then
    error "file ${STAGE_PATH}/lib/libsaga_api.${LINK_saga_version}.dylib does not exist... maybe you updated the saga version?"
  fi

  targets=(
    lib/saga/libclimate_tools.dylib
    lib/saga/libcontrib_perego.dylib
    lib/saga/libdb_pgsql.dylib
    lib/saga/libdocs_html.dylib
    lib/saga/libgarden_fractals.dylib
    lib/saga/libgarden_games.dylib
    lib/saga/libgarden_learn_to_program.dylib
    lib/saga/libgrid_analysis.dylib
    lib/saga/libgrid_calculus.dylib
    lib/saga/libgrid_calculus_bsl.dylib
    lib/saga/libgrid_filter.dylib
    lib/saga/libgrid_gridding.dylib
    lib/saga/libgrid_spline.dylib
    lib/saga/libgrid_tools.dylib
    lib/saga/libgrid_visualisation.dylib
    lib/saga/libgrids_tools.dylib
    lib/saga/libimagery_classification.dylib
    lib/saga/libimagery_maxent.dylib
    lib/saga/libimagery_photogrammetry.dylib
    lib/saga/libimagery_segmentation.dylib
    lib/saga/libimagery_svm.dylib
    lib/saga/libimagery_tools.dylib
    lib/saga/libio_esri_e00.dylib
    lib/saga/libio_gdal.dylib
    lib/saga/libio_gps.dylib
    lib/saga/libio_grid.dylib
    lib/saga/libio_shapes.dylib
    lib/saga/libio_shapes_dxf.dylib
    lib/saga/libio_table.dylib
    lib/saga/libio_virtual.dylib
    lib/saga/libpj_georeference.dylib
    lib/saga/libpj_proj4.dylib
    lib/saga/libpointcloud_tools.dylib
    lib/saga/libshapes_grid.dylib
    lib/saga/libshapes_lines.dylib
    lib/saga/libshapes_points.dylib
    lib/saga/libshapes_polygons.dylib
    lib/saga/libshapes_tools.dylib
    lib/saga/libshapes_transect.dylib
    lib/saga/libsim_cellular_automata.dylib
    lib/saga/libsim_ecosystems_hugget.dylib
    lib/saga/libsim_erosion.dylib
    lib/saga/libsim_geomorphology.dylib
    lib/saga/libsim_hydrology.dylib
    lib/saga/libsim_ihacres.dylib
    lib/saga/libsim_landscape_evolution.dylib
    lib/saga/libsim_qm_of_esp.dylib
    lib/saga/libsim_rivflow.dylib
    lib/saga/libstatistics_grid.dylib
    lib/saga/libstatistics_points.dylib
    lib/saga/libstatistics_regression.dylib
    lib/saga/libta_channels.dylib
    lib/saga/libta_compound.dylib
    lib/saga/libta_hydrology.dylib
    lib/saga/libta_lighting.dylib
    lib/saga/libta_morphometry.dylib
    lib/saga/libta_preprocessor.dylib
    lib/saga/libta_profiles.dylib
    lib/saga/libta_slope_stability.dylib
    lib/saga/libtable_calculus.dylib
    lib/saga/libtable_tools.dylib
    lib/saga/libtin_tools.dylib
    bin/saga_cmd
  )

  for i in ${targets[*]}
  do
    install_name_tool -change "${STAGE_PATH}/lib/libsaga_api.${LINK_saga_version}.dylib" "@rpath/libsaga_api.${LINK_saga_version}.dylib" ${STAGE_PATH}/$i
    if [[ $i == *"bin/"* ]]; then install_name_tool -add_rpath @executable_path/../lib $STAGE_PATH/$i; fi
  done
}

