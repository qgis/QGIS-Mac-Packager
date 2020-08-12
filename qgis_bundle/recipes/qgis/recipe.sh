#!/bin/bash

function check_qgis() {
  env_var_exists VERSION_qgis
  env_var_exists QGIS_INSTALL_DIR
  env_var_exists VERSION_grass_major
}

function bundle_qgis() {
  QGIS_CONTENTS_DIR=$QGIS_INSTALL_DIR/QGIS.app/Contents/
  QGIS_RECIPE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

  try cp -av $QGIS_CONTENTS_DIR/Info.plist $BUNDLE_CONTENTS_DIR
  try cp -av $QGIS_CONTENTS_DIR/PkgInfo $BUNDLE_CONTENTS_DIR
  try cp -av $QGIS_CONTENTS_DIR/MacOS/QGIS $BUNDLE_MACOS_DIR
  try cp -av $QGIS_RECIPE_DIR/../../../resources/pyqgis-startup.py $BUNDLE_RESOURCES_DIR/python/

  # LIBS
  try cp -av $QGIS_CONTENTS_DIR/MacOS/lib/libqgis_app.* $BUNDLE_LIB_DIR
  try cp -av $QGIS_CONTENTS_DIR/MacOS/lib/libqgispython.* $BUNDLE_LIB_DIR

  #### RESOURCES
  try rsync -av $QGIS_CONTENTS_DIR/Resources/ $BUNDLE_RESOURCES_DIR/ --exclude __pycache__

  #### FRAMEWORKS
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_analysis.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Header
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_core.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_gui.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_native.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_3d.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers

  #### PLUGINS
  try rsync -av $QGIS_CONTENTS_DIR/PlugIns/ $BUNDLE_PLUGINS_DIR/
}

function postbundle_qgis() {
 chmod +x $BUNDLE_CONTENTS_DIR/MacOS/QGIS

 # Patch Info.plist
 /usr/libexec/PlistBuddy -c "Add :LSMinimumSystemVersion string $MACOSX_DEPLOYMENT_TARGET" $BUNDLE_CONTENTS_DIR/Info.plist
 /usr/libexec/PlistBuddy -c "Add :LSFileQuarantineEnabled bool false" $BUNDLE_CONTENTS_DIR/Info.plist
 # PYQGIS_STARTUP should be relative to Contents/Resources/python
 /usr/libexec/PlistBuddy -c "Add :LSEnvironment:PYQGIS_STARTUP string pyqgis-startup.py" $BUNDLE_CONTENTS_DIR/Info.plist
 # PROJ_LIB see ../proj/recipe.sh
 # GDAL_DATA and GDAL_DRIVER_PATH see ../gdal/recipe.sh
 # PYTHONHOME see ../python/recipe.sh

 # RPATHS
 install_name_delete_rpath $DEPS_LIB_DIR $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_delete_rpath $QGIS_INSTALL_DIR/QGIS.app/Contents/MacOS/lib $BUNDLE_CONTENTS_DIR/MacOS/QGIS

 install_name_add_rpath @executable_path/../Frameworks $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_add_rpath @executable_path/lib $BUNDLE_CONTENTS_DIR/MacOS/QGIS

 install_name_id @rpath/libqgispython.$QGIS_VERSION.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib
 install_name_id @rpath/libqgis_app.$QGIS_VERSION.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_id @rpath/libqgis_customwidgets.$QGIS_VERSION.0.dylib $BUNDLE_CONTENTS_DIR/PlugIns/designer/libqgis_customwidgets.$QGIS_VERSION.0.dylib

 for i in \
    MacOS/QGIS \
    Frameworks/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core \
    Frameworks/qgis_3d.framework/Versions/$QGIS_VERSION/qgis_3d \
    Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis \
    Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui \
    Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} \
    PlugIns/qgis/libgeometrycheckerplugin.so \
    PlugIns/qgis/libdb2provider.so \
    PlugIns/qgis/libidentcertauthmethod.so \
    PlugIns/qgis/libtopolplugin.so \
    PlugIns/qgis/libgpxprovider.so \
    PlugIns/qgis/libesritokenauthmethod.so \
    PlugIns/qgis/libpostgresrasterprovider.so \
    PlugIns/qgis/libwcsprovider.so \
    PlugIns/qgis/libmdalprovider.so \
    PlugIns/qgis/libdelimitedtextprovider.so \
    PlugIns/qgis/libgpsimporterplugin.so \
    PlugIns/qgis/libspatialiteprovider.so \
    PlugIns/qgis/libgeonodeprovider.so \
    PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so \
    PlugIns/qgis/libwfsprovider.so \
    PlugIns/qgis/liboauth2authmethod.so \
    PlugIns/qgis/libbasicauthmethod.so \
    PlugIns/qgis/libarcgisfeatureserverprovider.so \
    PlugIns/qgis/libowsprovider.so \
    PlugIns/qgis/libpkipathsauthmethod.so \
    PlugIns/qgis/libwmsprovider.so \
    PlugIns/qgis/libofflineeditingplugin.so \
    PlugIns/qgis/libpkcs12authmethod.so \
    PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so \
    PlugIns/qgis/libmssqlprovider.so \
    PlugIns/qgis/libarcgismapserverprovider.so \
    PlugIns/qgis/libpostgresprovider.so \
    PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so \
    PlugIns/qgis/libvirtuallayerprovider.so \
    Resources/python/qgis/_core.so \
    Resources/python/qgis/_3d.so \
    Resources/python/qgis/_analysis.so \
    Resources/python/qgis/_gui.so \
    MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib \
    MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib \
    PlugIns/designer/libqgis_customwidgets.$QGIS_VERSION.0.dylib
 do
    for j in \
      $LINK_exiv2 \
      $LINK_expat \
      $LINK_gdal \
      $LINK_libgeos_c \
      $LINK_libgsl \
      $LINK_libgslcblas \
      $LINK_libzip \
      $LINK_libproj \
      $LINK_protobuf_lite \
      $LINK_libpq \
      $LINK_libqscintilla2_qt5 \
      $LINK_qtkeychain \
      $LINK_spatialindex \
      $LINK_spatialite \
      $LINK_sqlite \
      $LINK_zlib \
      $LINK_libtasn1 \
      $LINK_python \
      $LINK_libhdf5 \
      $LINK_libxml2 \
      $LINK_netcdf
    do
      install_name_change $DEPS_LIB_DIR/$j @rpath/$j $BUNDLE_CONTENTS_DIR/$i
    done

    for j in \
      libgrass_gis \
      libgrass_vector \
      libgrass_raster \
      libgrass_imagery \
      libgrass_dbmibase \
      libgrass_dbmiclient \
      libgrass_gproj
    do
      install_name_change $DEPS_GRASS_LIB_DIR/$j.${VERSION_grass_major}.${VERSION_grass_minor}.dylib @rpath/$j.${VERSION_grass_major}.${VERSION_grass_minor}.dylib $BUNDLE_CONTENTS_DIR/$i
    done

    install_name_change $QGIS_BUILD_DIR/output/lib/libqgis_app.$QGIS_VERSION.0.dylib @rpath/libqgis_app.$QGIS_VERSION.0.dylib $BUNDLE_CONTENTS_DIR/$i
    install_name_change $DEPS_LIB_DIR/$LINK_qca.framework/Versions/${VERSION_qca}/$LINK_qca @rpath/$LINK_qca.framework/Versions/${VERSION_qca}/$LINK_qca $BUNDLE_CONTENTS_DIR/$i

    for j in \
      qgis_core \
      qgis_gui \
      qgis_native \
      qgis_3d \
      qgisgrass${VERSION_grass_major} \
      libgrass_dbmiclient \
      libgrass_gproj
    do
      install_name_id @rpath/$j.framework/Versions/$QGIS_VERSION/$j $BUNDLE_CONTENTS_DIR/Frameworks/$j.framework/Versions/$QGIS_VERSION/$j
      install_name_change $QGIS_BUILD_DIR/output/lib/$j.framework/Versions/$QGIS_VERSION/$j @rpath/$j.framework/Versions/$QGIS_VERSION/$j $BUNDLE_CONTENTS_DIR/$i
    done
 done
}
