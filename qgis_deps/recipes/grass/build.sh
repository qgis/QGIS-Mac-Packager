function build_grass() {
  try cd ${DEPS_BUILD_PATH}/grass/build-$ARCH
  push_env

  # No DEBUG symbols!
  export PATH="$STAGE_PATH/grass${VERSION_grass_major}${VERSION_grass_minor}/bin:$PATH"

  # headerpad_max_install_names is to be able to modify/add rpaths to binaries in bundle step
  unset LDFLAGS
  export LDFLAGS="-Wl,-headerpad_max_install_names"
  export CFLAGS="-O2"
  export CXXFLAGS="${CFLAGS}"
  export GRASS_PYTHON=$STAGE_PATH/bin/python3

  # when building with LIB=...
  # lib/gpde fails with undefined symbols to _G_calloc and others
  # see https://github.com/OSGeo/grass/issues/457#issuecomment-607272665
  unset LIB
  unset INCLUDE
  unset LIB_DIR

  try ${CONFIGURE} \
    --with-cxx \
    --enable-shared \
    --exec_prefix=$STAGE_PATH \
    --with-includes=$STAGE_PATH/include \
    --with-libs=$STAGE_PATH/lib \
    --without-tcltk \
    --with-netcdf=$STAGE_PATH/bin/nc-config \
    --with-zstd \
    --with-zstd-includes=$STAGE_PATH/include \
    --with-zstd-libs=$STAGE_PATH/lib \
    --with-geos=$STAGE_PATH/bin/geos-config \
    --with-geos-includes=$STAGE_PATH/include \
    --with-geos-libs=$STAGE_PATH/lib \
    --with-gdal=$STAGE_PATH/bin/gdal-config \
    --with-zlib-includes=$STAGE_PATH/include \
    --with-zlib-libs=$STAGE_PATH/lib \
    --with-proj-includes=$STAGE_PATH/include \
    --with-proj-libs=$STAGE_PATH/lib \
    --with-proj-share=$STAGE_PATH/share/proj \
    --with-tiff \
    --with-tiff-includes=$STAGE_PATH/include \
    --with-tiff-libs=$STAGE_PATH/lib \
    --with-png \
    --with-png-includes=$STAGE_PATH/include \
    --with-png-libs=$STAGE_PATH/lib \
    --with-sqlite \
    --with-sqlite-includes=$STAGE_PATH/include \
    --with-sqlite-libs=$STAGE_PATH/lib \
    --without-fftw \
    --without-postgres \
    --without-mysql \
    --with-pthread \
    --with-pthread-includes=$STAGE_PATH/include/boost/thread \
    --with-pthread-libs=$STAGE_PATH/lib \
    --without-pdal \
    --without-opendwg \
    --without-opencl \
    --without-opengl \
    --without-motif \
    --without-glw \
    --without-wxwidgets \
    --without-cairo \
    --enable-64bit \
    --without-freetype

  check_file_configuration config.status

  # plain Make fails to run, since it expects some libraries in stage,
  # even before libs like libgrass_gis.dylib are installed in stage dir
  # see https://github.com/OSGeo/grass/issues/474#issuecomment-609011156
  $MAKESMP
  try $MAKE install

  # OK now we can build everything else
  try $MAKESMP
  try $MAKE install

  # NOTE 1:
  # bunch of errors from stdio.h similar to
  # SDKs/MacOSX.sdk/usr/include/sys/stdio.h:39: Syntax error at '__attribute__'
  # very scary but compilation passes?
  # see https://github.com/OSGeo/grass/issues/474#issuecomment-609011006

  # fix permissions
  chmod 777 $STAGE_PATH/grass${VERSION_grass_major}${VERSION_grass_minor}/etc/colors/grass

  pop_env
}
