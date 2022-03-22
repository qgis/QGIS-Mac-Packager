function build_ecw() {
  try cd ${DEPS_BUILD_PATH}/gdal/build-${ARCH}

  if [[ "${WITH_ECW}" == "true" ]]; then
    info "building GDAL ECW driver to ${GDAL_NOFOSS_PLUGINS_DIR}"

    if [ ! -d "${ECW_SDK}" ]; then
      echo "Missing ECW SDK in ${ECW_SDK}"
      exit 1
    fi

    SRC=$(find frmts/ecw -name *.cpp)

    try ${CXX} -std=c++14 \
      -Iport -Igcore -Ifrmts -Iogr -DFRMT_ecw -DECWSDK_VERSION=55 -Ifrmts/ecw -DDO_NOT_USE_DEBUG_BOOL \
      -I${ECW_SDK}/include -I${ECW_SDK}/include/NCSEcw/API \
      -I${ECW_SDK}/include/NCSEcw/ECW -I${ECW_SDK}/include/NCSEcw/JP2 \
      ${SRC} \
      -dynamiclib \
      -install_name ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_ecw} \
      -current_version ${VERSION_gdal} \
      -compatibility_version ${VERSION_gdal} \
      -o ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_ecw} \
      -undefined dynamic_lookup \
      -L${ECW_SDK}/lib -lNCSEcw
  fi
}
function build_mrsid() {
  try cd ${DEPS_BUILD_PATH}/gdal/build-${ARCH}

  if [[ "${WITH_MRSID}" == "true" ]]; then
    if [ ! -d "${MRSID_SDK}" ]; then
      echo "Missing MRSID SDK in ${MRSID_SDK}"
      exit 1
    fi

    # LIDAR
    info "building GDAL MrSID Lidar driver to ${GDAL_NOFOSS_PLUGINS_DIR}"
    SRC=$(find frmts/mrsid_lidar -name *.c*)
    try ${CXX} -std=c++14 \
       -Iport -Igcore -Ifrmts -Iogr -Ifrmts/mrsid_lidar \
      -I${MRSID_SDK}/Lidar_DSDK/include \
      ${SRC} \
      -dynamiclib \
      -install_name ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_mrsid_lidar} \
      -current_version ${VERSION_gdal} \
      -compatibility_version ${VERSION_gdal} \
      -o ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_mrsid_lidar} \
      -undefined dynamic_lookup \
      -L${MRSID_SDK}/Lidar_DSDK/lib -llti_lidar_dsdk

    # RASTER
    info "building GDAL MRSID driver to ${GDAL_NOFOSS_PLUGINS_DIR}"
    SRC=$(find frmts/mrsid -name *.c*)
    try ${CXX} -std=c++14 \
      -DMRSID_J2K=1 \
      -Iport -Igcore -Ifrmts -Iogr -Ifrmts/mrsid -Ifrmts/gtiff/libgeotiff \
      -I${MRSID_SDK}/Raster_DSDK/include \
      ${SRC} \
      -dynamiclib \
      -install_name ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_mrsid_raster} \
      -current_version ${VERSION_gdal} \
      -compatibility_version ${VERSION_gdal} \
      -o ${GDAL_NOFOSS_PLUGINS_DIR}/${LINK_gdal_mrsid_raster} \
      -undefined dynamic_lookup \
      -L${MRSID_SDK}/Raster_DSDK/lib -lltidsdk
  fi
}
function build_gdal() {
  try cd ${DEPS_BUILD_PATH}/gdal/build-${ARCH}
  push_env

  try mkdir -p ${GDAL_NOFOSS_PLUGINS_DIR}
  try mkdir -p ${GDAL_PLUGINS_DIR}

  # add unixodbc
  export CFLAGS="${CFLAGS} -I${STAGE_PATH}/unixodbc/include"
  export LDFLAGS="${LDFLAGS} -L${STAGE_PATH}/unixodbc/lib"
  export CXXFLAGS="${CFLAGS}"

  info $PKG_CONFIG
  info $PKG_CONFIG_PATH

  try ${CONFIGURE} \
    --with-threads --disable-static \
    --disable-debug \
    --enable-driver-gml \
    --enable-driver-gpkg \
    --enable-driver-mbtiles \
    --enable-driver-mssqlspatial \
    --enable-driver-mvt \
    --enable-driver-xlsx \
    --with-cfitsio=no \
    --with-cpp14 \
    --with-cryptopp=no \
    --with-ecw=no \
    --with-expat-inc=${STAGE_PATH}/include \
    --with-expat-lib="-lexpat" \
    --with-expat=${STAGE_PATH} \
    --with-exr=no \
    --with-freexl=${STAGE_PATH} \
    --with-geotiff=${STAGE_PATH} \
    --with-gif=internal \
    --with-hdf5=${STAGE_PATH} \
    --with-heif=no \
    --with-qhull=internal \
    --with-jpeg=${STAGE_PATH} \
    --with-libjson-c=internal \
    --with-lerc=${STAGE_PATH} \
    --with-libkml=${STAGE_PATH} \
    --with-liblzma=${STAGE_PATH} \
    --with-libtiff=${STAGE_PATH} \
    --with-lz4=no \
    --with-mrsid=no \
    --with-netcdf=${STAGE_PATH} \
    --with-odbc=yes \
    --with-pcre2 \
    --with-png=${STAGE_PATH} \
    --with-poppler=${STAGE_PATH} \
    --with-spatialite=${STAGE_PATH} \
    --with-sqlite3=${STAGE_PATH} \
    --with-xerces-inc=${STAGE_PATH}/include \
    --with-xerces-lib="-lxerces-c" \
    --with-xerces=${STAGE_PATH} \
    --with-zstd=${STAGE_PATH} \
    --without-libtool

  #check_file_configuration config.status

  try ${MAKESMP}
  try ${MAKESMP} install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_gdal $STAGE_PATH/lib/$LINK_gdal
  try install_name_tool -change ${DEPS_BUILD_PATH}/gdal/build-$ARCH/lib/$LINK_gdal $STAGE_PATH/lib/$LINK_gdal $STAGE_PATH/lib/$LINK_gdal

  build_ecw
  build_mrsid

  pop_env
}
