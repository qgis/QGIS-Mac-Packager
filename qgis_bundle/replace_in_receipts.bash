#!/usr/bin/env bash

# script to convert the results from find_that_link.bash to some
# useful stuff usable generally (e.g. replacing the abs. paths and so on)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/config.conf
SED="sed -i.orig"

function replace_in_place() {
  FILE=$1
  SRC=$2
  DEST=$3
  $SED "s;$SRC;$DEST;g" $FILE
  rm $FILE.orig
}


function run() {
  RECIPES=`find $DIR/recipes -type f`
  for recipe in $RECIPES; do
    echo "Patching $recipe"

    # general stuff
    replace_in_place $recipe $DEPS_LIB_DIR "\$DEPS_LIB_DIR"

    # qgis
    replace_in_place $recipe "framework/Versions/$QGIS_VERSION/qgis" "framework/Versions/\$QGIS_VERSION/qgis"
    replace_in_place $recipe libqgis_app.$QGIS_VERSION.0.dylib libqgis_app.\$QGIS_VERSION.0.dylib
    replace_in_place $recipe libqgispython.$QGIS_VERSION.0.dylib libqgispython.\$QGIS_VERSION.0.dylib

    # libs
    replace_in_place $recipe $LINK_exiv2 "\$LINK_exiv2"
    replace_in_place $recipe $LINK_expat "\$LINK_expat"
    replace_in_place $recipe $LINK_freexl "\$LINK_freexl"
    replace_in_place $recipe $LINK_gdal "\$LINK_gdal"
    replace_in_place $recipe $LINK_libgeos_c "\$LINK_libgeos_c"

    replace_in_place $recipe $DEPS_GRASS_LIB_DIR \$DEPS_GRASS_LIB_DIR
    replace_in_place $recipe "libgrass\([a-z_]*\).${VERSION_grass_major}.${VERSION_grass_minor}.dylib" "libgrass\\1.\$\{VERSION_grass_major}.\$\{VERSION_grass_minor}.dylib"
    replace_in_place $recipe libgrassplugin${VERSION_grass_major}.so libgrassplugin\$\{VERSION_grass_major}.so
    replace_in_place $recipe libgrassprovider${VERSION_grass_major}.so libgrassprovider\$\{VERSION_grass_major}.so
    replace_in_place $recipe libgrassrasterprovider${VERSION_grass_major}.so libgrassrasterprovider\$\{VERSION_grass_major}.so
    replace_in_place $recipe qgisgrass${VERSION_grass_major} qgisgrass\$\{VERSION_grass_major}
    replace_in_place $recipe grass${VERSION_grass_major}${VERSION_grass_minor} grass\$\{VERSION_grass_major}\$\{VERSION_grass_minor}
    replace_in_place $recipe grass${VERSION_grass_major}${VERSION_grass_minor} grass\$\{VERSION_grass_major}\$\{VERSION_grass_minor}

    replace_in_place $recipe $LINK_libgsl "\$LINK_libgsl"
    replace_in_place $recipe $LINK_libgslcblas "\$LINK_libgslcblas"
    replace_in_place $recipe $LINK_libhdf5 "\$LINK_libhdf5"
    replace_in_place $recipe $LINK_libhdf5_hl "\$LINK_libhdf5_hl"
    replace_in_place $recipe $LINK_jpeg "\$LINK_jpeg"
    replace_in_place $recipe $LINK_libffi "\$LINK_libffi"
    replace_in_place $recipe $LINK_libtasn1 "\$LINK_libtasn1"
    # libgeotiff is just static lib?
    replace_in_place $recipe $LINK_libtiff "\$LINK_libtiff"
    replace_in_place $recipe $LINK_libltdl "\$LINK_libltdl"
    replace_in_place $recipe $LINK_libxml2 "\$LINK_libxml2"
    replace_in_place $recipe $LINK_libxslt "\$LINK_libxslt"
    replace_in_place $recipe $LINK_libzip "\$LINK_libzip"
    replace_in_place $recipe $LINK_libmysqlclient "\$LINK_libmysqlclient"
    replace_in_place $recipe $LINK_netcdf "\$LINK_netcdf"
    replace_in_place $recipe $LINK_libssl "\$LINK_libssl"
    replace_in_place $recipe $LINK_libcrypto "\$LINK_libcrypto"
    replace_in_place $recipe $LINK_libpng "\$LINK_libpng"
    replace_in_place $recipe $LINK_libpq "\$LINK_libpq"
    replace_in_place $recipe $LINK_libproj "\$LINK_libproj"
    replace_in_place $recipe $LINK_protobuf_lite "\$LINK_protobuf_lite"
    replace_in_place $recipe $LINK_python "\$LINK_python"
    # python packages ?
    replace_in_place $recipe $LINK_qca "\$LINK_qca"
    replace_in_place $recipe $LINK_libqscintilla2_qt5 "\$LINK_libqscintilla2_qt5"
    replace_in_place $recipe $LINK_qtkeychain "\$LINK_qtkeychain"
    # replace_in_place $recipe $LINK_qtkeychain "\$LINK_qtkeychain" ! qwt
    replace_in_place $recipe $LINK_saga "\$LINK_saga"
    replace_in_place $recipe $LINK_spatialindex "\$LINK_spatialindex"
    replace_in_place $recipe $LINK_spatialite "\$LINK_spatialite"
    replace_in_place $recipe $LINK_sqlite "\$LINK_sqlite"
    replace_in_place $recipe $LINK_unixodbc "\$LINK_unixodbc"
    replace_in_place $recipe $LINK_libwebp "\$LINK_libwebp"
    replace_in_place $recipe $LINK_libwebpdemux "\$LINK_libwebpdemux"

    replace_in_place $recipe "libwx_\([a-z_]*\)-${LINK_wxmac_version}.dylib" "libwx_\\1-\$\{LINK_wxmac_version}.dylib"
    replace_in_place $recipe "libwx_\([a-z_]*\)-${VERSION_wxmac_major}.dylib" "libwx_\\1-\$\{VERSION_wxmac_major}.dylib"
    
    replace_in_place $recipe $LINK_liblzma "\$LINK_liblzma"
    replace_in_place $recipe $LINK_zlib "\$LINK_zlib"
    replace_in_place $recipe $LINK_zstd "\$LINK_zstd"

  done
}



run