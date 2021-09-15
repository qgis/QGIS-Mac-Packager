#!/bin/bash

BUNDLE_GDAL_PLUGINS_DIR=$BUNDLE_LIB_DIR/gdalplugins
LINK_MRSID_SDK_lti_lidar_dsdk=liblti_lidar_dsdk.1.dylib
LINK_MRSID_SDK_libtbb=libtbb.dylib
LINK_MRSID_SDK_libltidsdk=libltidsdk.9.dylib

function check_gdal() {
  env_var_exists VERSION_gdal
  env_var_exists LINK_gdal
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_gdal() {
  try cp -av $DEPS_LIB_DIR/libgdal*dylib $BUNDLE_LIB_DIR

  # GDAL binaries
  GDAL_RECIPE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  try cp -av $GDAL_RECIPE_DIR/run_gdal_binary.bash $BUNDLE_BIN_DIR/
  chmod +x $BUNDLE_BIN_DIR/run_gdal_binary.bash
  for i in \
    gdal_contour \
    gdal_grid \
    gdal_rasterize \
    gdal_translate \
    gdal_viewshed \
    gdaladdo \
    gdalbuildvrt \
    gdaldem \
    gdalenhance \
    gdalinfo \
    gdallocationinfo \
    gdalmanage \
    gdalmdiminfo \
    gdalmdimtranslate \
    gdalsrsinfo \
    gdaltindex \
    gdaltransform \
    gdalwarp \
    ogr2ogr \
    ogrinfo \
    ogrlineref \
    ogrtindex
  do
    touch $BUNDLE_BIN_DIR/$i
    chmod +x $BUNDLE_BIN_DIR/$i
    echo "#!/bin/bash" >> $BUNDLE_BIN_DIR/$i
    echo 'THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"' >> $BUNDLE_BIN_DIR/$i
    echo '$THISDIR/run_gdal_binary.bash "'$i'" "$@"'  >> $BUNDLE_BIN_DIR/$i

    try cp -av $DEPS_BIN_DIR/$i $BUNDLE_BIN_DIR/_$i
  done

  # GDAL plugins
  # https://github.com/qgis/QGIS/blob/518cc16e87aba6798658acf75c86f27a0f4d99b3/src/app/main.cpp#L1198
  # should be in Contents/MacOS/lib/gdalplugins
  DEPS_GDAL_NOFOSS_PLUGINS_DIR=$DEPS_LIB_DIR/../3rdParty/gdalplugins
  try mkdir $BUNDLE_GDAL_PLUGINS_DIR
  # folder for some 3rdparty SDKs and libs
  try mkdir $BUNDLE_GDAL_PLUGINS_DIR/3rdparty

  if [[ "$WITH_ECW" == "true" ]]; then
    try cp -av $DEPS_GDAL_NOFOSS_PLUGINS_DIR/$LINK_gdal_ecw $BUNDLE_GDAL_PLUGINS_DIR/
  fi

  if [[ "$WITH_MRSID" == "true" ]]; then
    try cp -av $DEPS_GDAL_NOFOSS_PLUGINS_DIR/$LINK_gdal_mrsid_raster $BUNDLE_GDAL_PLUGINS_DIR/
    try cp -av $DEPS_GDAL_NOFOSS_PLUGINS_DIR/$LINK_gdal_mrsid_lidar $BUNDLE_GDAL_PLUGINS_DIR/

    MRSID_SDK="$QGIS_BUNDLE_SCRIPT_DIR/../../external/$MRSID_SDK_VER"
    if [ ! -d "$MRSID_SDK" ]; then
      echo "Missing MRSID SDK in $MRSID_SDK"
      exit 1
    fi
    try cp -av $MRSID_SDK/Lidar_DSDK/lib/$LINK_MRSID_SDK_lti_lidar_dsdk $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/
    try cp -av $MRSID_SDK/Lidar_DSDK/lib/$LINK_MRSID_SDK_libtbb $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/
    try cp -av $MRSID_SDK/Raster_DSDK/lib/$LINK_MRSID_SDK_libltidsdk $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/
  fi

  # GDAL data
  # https://github.com/qgis/QGIS/blob/518cc16e87aba6798658acf75c86f27a0f4d99b3/src/app/main.cpp#L1205
  # should be Contents/Resources/gdal
  try rsync -av $DEPS_SHARE_DIR/gdal $BUNDLE_RESOURCES_DIR/
}

function fix_binaries_gdal() {
  install_name_id @rpath/$LINK_gdal $BUNDLE_LIB_DIR/$LINK_gdal

  for i in \
    bin/_gdal_contour \
    bin/_gdal_grid \
    bin/_gdal_rasterize \
    bin/_gdal_translate \
    bin/_gdal_viewshed \
    bin/_gdaladdo \
    bin/_gdalbuildvrt \
    bin/_gdaldem \
    bin/_gdalenhance \
    bin/_gdalinfo \
    bin/_gdallocationinfo \
    bin/_gdalmanage \
    bin/_gdalmdiminfo \
    bin/_gdalmdimtranslate \
    bin/_gdalsrsinfo \
    bin/_gdaltindex \
    bin/_gdaltransform \
    bin/_gdalwarp \
    bin/_ogr2ogr \
    bin/_ogrinfo \
    bin/_ogrlineref \
    bin/_ogrtindex \
    lib/$LINK_gdal
  do
      for j in \
        $LINK_freexl \
        $LINK_libgeos_c \
        $LINK_libhdf5 \
        $LINK_netcdf \
        $LINK_jpeg \
        $LINK_libtiff \
        $LINK_libxml2 \
        $LINK_libcrypto \
        $LINK_libssl \
        $LINK_libpng \
        $LINK_libpq \
        $LINK_libproj \
        $LINK_spatialite \
        $LINK_sqlite \
        $LINK_libwebp \
        $LINK_libxerces_c \
        $LINK_zlib \
        $LINK_zstd \
        $LINK_libkmlbase \
        $LINK_libkmlconvenience \
        $LINK_libkmldom \
        $LINK_libkmlengine \
        $LINK_libkmlregionator \
        $LINK_libkmlxsd \
        $LINK_libminizip \
        $LINK_expat \
        $LINK_liburiparser \
        $LINK_pcre \
        $LINK_poppler \
        $LINK_openjpeg \
        $LINK_libltdl \
        $LINK_libcurl \
        $LINK_libssh2 \
        $LINK_gdal \
        $LINK_rttopo
      do
         install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_CONTENTS_DIR/MacOS/$i
      done

      install_name_change $QGIS_DEPS_STAGE_PATH/unixodbc/lib/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_CONTENTS_DIR/MacOS/$i
      install_name_change $QGIS_DEPS_STAGE_PATH/unixodbc/lib/$LINK_unixodbcinst @rpath/$LINK_unixodbcinst $BUNDLE_CONTENTS_DIR/MacOS/$i
  done

  # bin/gdal_viewshed \
  for i in \
    bin/_gdal_contour \
    bin/_gdal_grid \
    bin/_gdal_rasterize \
    bin/_gdal_translate \
    bin/_gdaladdo \
    bin/_gdalbuildvrt \
    bin/_gdaldem \
    bin/_gdalenhance \
    bin/_gdalinfo \
    bin/_gdallocationinfo \
    bin/_gdalmanage \
    bin/_gdalmdiminfo \
    bin/_gdalmdimtranslate \
    bin/_gdalsrsinfo \
    bin/_gdaltindex \
    bin/_gdaltransform \
    bin/_gdalwarp \
    bin/_ogr2ogr \
    bin/_ogrinfo \
    bin/_ogrlineref \
    bin/_ogrtindex
  do
     install_name_add_rpath @executable_path/../../Frameworks $BUNDLE_CONTENTS_DIR/MacOS/$i
     install_name_add_rpath @executable_path/../lib $BUNDLE_CONTENTS_DIR/MacOS/$i
  done

  if [[ "$WITH_ECW" == "true" ]]; then
    install_name_id @rpath/gdalplugins/$LINK_gdal_ecw $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_ecw
    install_name_change $DEPS_LIB_DIR/gdalplugins/$LINK_gdal_ecw @rpath/gdalplugins/$LINK_gdal_ecw $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_ecw
  fi

  if [[ "$WITH_MRSID" == "true" ]]; then
    install_name_id @rpath/gdalplugins/$LINK_gdal_mrsid_lidar $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_lidar
    install_name_change $DEPS_LIB_DIR/gdalplugins/$LINK_gdal_mrsid_raster @rpath/gdalplugins/$LINK_gdal_mrsid_lidar $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_raster
    install_name_id @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_lti_lidar_dsdk $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_lti_lidar_dsdk
    install_name_id @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_libtbb $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_libtbb
    install_name_change @rpath/$LINK_MRSID_SDK_lti_lidar_dsdk @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_lti_lidar_dsdk $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_lidar
    install_name_change @rpath/$LINK_MRSID_SDK_libtbb @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_libtbb $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_lti_lidar_dsdk

    install_name_id @rpath/gdalplugins/$LINK_gdal_mrsid_raster $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_raster
    install_name_change $DEPS_LIB_DIR/gdalplugins/$LINK_gdal_mrsid_raster @rpath/gdalplugins/$LINK_gdal_mrsid_raster $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_raster
    install_name_id @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_libltidsdk $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_libltidsdk
    install_name_change @rpath/$LINK_MRSID_SDK_libltidsdk @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_libltidsdk $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_raster
    install_name_change @rpath/$LINK_MRSID_SDK_libtbb @rpath/gdalplugins/3rdparty/$LINK_MRSID_SDK_libtbb $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_libltidsdk
  fi
}

function fix_binaries_gdal_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_gdal
  verify_binary $BUNDLE_BIN_DIR/_gdalinfo

  if [[ "$WITH_ECW" == "true" ]]; then
    verify_binary $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_ecw
  fi

  if [[ "$WITH_MRSID" == "true" ]]; then
    verify_binary $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_raster
    verify_binary $BUNDLE_GDAL_PLUGINS_DIR/$LINK_gdal_mrsid_lidar
    verify_binary $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_libtbb
    verify_binary $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_lti_lidar_dsdk
    verify_binary $BUNDLE_GDAL_PLUGINS_DIR/3rdparty/$LINK_MRSID_SDK_libltidsdk
  fi
}

function fix_paths_gdal() {
  :
}

function fix_paths_gdal_check() {
  :
}
