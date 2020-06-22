#!/bin/bash

function check_qgis() {
  env_var_exists VERSION_qgis
  env_var_exists QGIS_INSTALL_DIR
  env_var_exists VERSION_grass_major
}

function bundle_qgis() {
  QGIS_CONTENTS_DIR=$QGIS_INSTALL_DIR/QGIS.app/Contents/

  try cp -av $QGIS_CONTENTS_DIR/Info.plist $BUNDLE_CONTENTS_DIR
  try cp -av $QGIS_CONTENTS_DIR/PkgInfo $BUNDLE_CONTENTS_DIR

  try cp -av $QGIS_CONTENTS_DIR/MacOS/QGIS $BUNDLE_MACOS_DIR

  try cp -av $QGIS_CONTENTS_DIR/MacOS/lib/libqgis_app.* $BUNDLE_LIB_DIR
  try cp -av $QGIS_CONTENTS_DIR/MacOS/lib/libqgispython.* $BUNDLE_LIB_DIR

  try rsync -av $QGIS_CONTENTS_DIR/PlugIns/ $BUNDLE_PLUGINS_DIR/
  try rsync -av $QGIS_CONTENTS_DIR/Resources/ $BUNDLE_RESOURCES_DIR/ --exclude __pycache__

  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_analysis.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Header
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_core.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_gui.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_native.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_3d.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function postbundle_qgis() {
 chmod +x $BUNDLE_CONTENTS_DIR/MacOS/QGIS

 install_name_delete_rpath $DEPS_LIB_DIR $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 # install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 # install_name_delete_rpath $ROOT_OUT_PATH/../qgis-$QGIS_VERSION-deps-${RELEASE_VERSION}/install/QGIS.app/Contents/MacOS/lib $BUNDLE_CONTENTS_DIR/MacOS/QGIS

 install_name_add_rpath @executable_path/../Frameworks $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_add_rpath @executable_path/lib $BUNDLE_CONTENTS_DIR/MacOS/QGIS

 ## PYTHON
 install_name_id @rpath/libqgispython.$QGIS_VERSION.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib

 ## CORE
 install_name_id @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Frameworks/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core

 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Frameworks/qgis_3d.framework/Versions/$QGIS_VERSION/qgis_3d
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdb2provider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libidentcertauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libtopolplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpxprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libesritokenauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresrasterprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwcsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdelimitedtextprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpsimporterplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libspatialiteprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeonodeprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwfsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/liboauth2authmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libbasicauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgisfeatureserverprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libowsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkipathsauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwmsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libofflineeditingplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkcs12authmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmssqlprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgismapserverprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libvirtuallayerprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_core.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_3d.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_gui.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core @rpath/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib
 
 ## GUI
 install_name_id @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui

 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdb2provider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libidentcertauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libtopolplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libesritokenauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwcsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdelimitedtextprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpsimporterplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libspatialiteprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeonodeprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwfsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/liboauth2authmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libbasicauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgisfeatureserverprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libowsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkipathsauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwmsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libofflineeditingplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkcs12authmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmssqlprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgismapserverprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libvirtuallayerprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_gui.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui @rpath/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib

 ## ANALYSIS
 install_name_id @rpath/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis

 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis @rpath/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis @rpath/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis @rpath/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis @rpath/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis @rpath/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib

 ## NATIVE
 install_name_id @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Frameworks/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native

 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Frameworks/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Frameworks/qgis_3d.framework/Versions/$QGIS_VERSION/qgis_3d
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdb2provider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libidentcertauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libtopolplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpxprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libesritokenauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresrasterprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwcsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdelimitedtextprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpsimporterplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libspatialiteprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeonodeprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwfsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/liboauth2authmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libbasicauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgisfeatureserverprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libowsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkipathsauthmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwmsprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libofflineeditingplugin.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkcs12authmethod.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmssqlprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgismapserverprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libvirtuallayerprovider.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_core.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_3d.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_gui.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_change $QGIS_BUILD_DIR/output/lib/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native @rpath/qgis_native.framework/Versions/$QGIS_VERSION/qgis_native $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib

 # GRASS
 install_name_change $QGIS_BUILD_DIR/output/lib/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} @rpath/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $QGIS_BUILD_DIR/output/lib/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} @rpath/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} @rpath/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $QGIS_BUILD_DIR/output/lib/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} @rpath/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major} $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
}

function add_config_info_qgis() {
    :
}
