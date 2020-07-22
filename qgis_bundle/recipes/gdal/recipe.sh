#!/bin/bash

function check_gdal() {
  env_var_exists VERSION_gdal
  env_var_exists LINK_gdal
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_gdal() {
  try cp -av $DEPS_LIB_DIR/libgdal*dylib $BUNDLE_LIB_DIR

  # GDAL plugins
  # https://github.com/qgis/QGIS/blob/518cc16e87aba6798658acf75c86f27a0f4d99b3/src/app/main.cpp#L1198
  # should be in Contents/MacOS/lib/gdalplugins
  # we do not have any gdalplugins yet
  try mkdir $BUNDLE_CONTENTS_DIR/MacOS/lib/gdalplugins

  # GDAL data
  # https://github.com/qgis/QGIS/blob/518cc16e87aba6798658acf75c86f27a0f4d99b3/src/app/main.cpp#L1205
  # should be Contents/Resources/gdal
  try rsync -av $DEPS_SHARE_DIR/gdal $BUNDLE_RESOURCES_DIR/
}

function postbundle_gdal() {
 install_name_id @rpath/$LINK_gdal $BUNDLE_LIB_DIR/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Frameworks/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Frameworks/qgis_3d.framework/Versions/$QGIS_VERSION/qgis_3d
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdb2provider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libidentcertauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libtopolplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpxprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libesritokenauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresrasterprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwcsprovider.so

 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdelimitedtextprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpsimporterplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libspatialiteprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeonodeprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwfsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/liboauth2authmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libbasicauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgisfeatureserverprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libowsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkipathsauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwmsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libofflineeditingplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkcs12authmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmssqlprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgismapserverprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/designer/libqgis_customwidgets.$QGIS_VERSION.0.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libvirtuallayerprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_core.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_3d.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_gui.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_gdal.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_vector.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.${VERSION_grass_major}.${VERSION_grass_minor}.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/osgeo/_osr.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/osgeo/_gdal_array.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/osgeo/_gdal.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/osgeo/_ogr.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/osgeo/_gnm.cpython-${VERSION_major_python//./}m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_gdal @rpath/$LINK_gdal $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/GDAL-${VERSION_gdal}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/osgeo/_gdalconst.cpython-${VERSION_major_python//./}m-darwin.so
}

