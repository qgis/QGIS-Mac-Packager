#!/bin/bash

function check_proj() {
  env_var_exists VERSION_proj
  env_var_exists LINK_libproj
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_proj() {
  try cp -av $DEPS_LIB_DIR/libproj*dylib $BUNDLE_LIB_DIR
  try rsync -av $DEPS_SHARE_DIR/proj $BUNDLE_RESOURCES_DIR/
}

function postbundle_proj() {
 install_name_id  @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libproj

 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Frameworks/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Frameworks/qgis_3d.framework/Versions/$QGIS_VERSION/qgis_3d
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdb2provider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libidentcertauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libtopolplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpxprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libevis.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libesritokenauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresrasterprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwcsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libcoordinatecaptureplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdelimitedtextprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpsimporterplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libspatialiteprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeonodeprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwfsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/liboauth2authmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libbasicauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgisfeatureserverprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libowsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkipathsauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwmsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libofflineeditingplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkcs12authmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmssqlprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgismapserverprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeorefplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin7.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libvirtuallayerprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_core.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_3d.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_gui.so
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpj_proj4.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gproj.7.8.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libspatialite.7.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-2.6.0-py3.7-macosx-10.13.0-x86_64.egg/pyproj/_list.cpython-37m-darwin.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-2.6.0-py3.7-macosx-10.13.0-x86_64.egg/pyproj/_datadir.cpython-37m-darwin.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-2.6.0-py3.7-macosx-10.13.0-x86_64.egg/pyproj/_crs.cpython-37m-darwin.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-2.6.0-py3.7-macosx-10.13.0-x86_64.egg/pyproj/_geod.cpython-37m-darwin.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-2.6.0-py3.7-macosx-10.13.0-x86_64.egg/pyproj/_proj.cpython-37m-darwin.so
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libproj.18.dylib @rpath/libproj.18.dylib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/pyproj-2.6.0-py3.7-macosx-10.13.0-x86_64.egg/pyproj/_transformer.cpython-37m-darwin.so
}

function add_config_info_proj() {
    :
}

