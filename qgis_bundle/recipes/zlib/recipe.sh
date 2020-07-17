#!/bin/bash

function check_zlib() {
  env_var_exists VERSION_zlib
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists LINK_zlib
}

function bundle_zlib() {
    try cp -av $DEPS_LIB_DIR/libz.*dylib $BUNDLE_LIB_DIR
}

function postbundle_zlib() {
 install_name_id @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_zlib

 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/QGIS
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Frameworks/qgis_core.framework/Versions/$QGIS_VERSION/qgis_core
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Frameworks/qgis_3d.framework/Versions/$QGIS_VERSION/qgis_3d
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Frameworks/qgis_analysis.framework/Versions/$QGIS_VERSION/qgis_analysis
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Frameworks/qgis_gui.framework/Versions/$QGIS_VERSION/qgis_gui
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Frameworks/qgisgrass${VERSION_grass_major}.framework/Versions/$QGIS_VERSION/qgisgrass${VERSION_grass_major}
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeometrycheckerplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdb2provider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libidentcertauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libtopolplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpxprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libesritokenauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresrasterprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwcsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libdelimitedtextprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgpsimporterplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libspatialiteprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgeonodeprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassrasterprovider${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwfsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/liboauth2authmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libbasicauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgisfeatureserverprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libowsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkipathsauthmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libwmsprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libofflineeditingplugin.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpkcs12authmethod.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassprovider${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmssqlprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libarcgismapserverprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libpostgresprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libgrassplugin${VERSION_grass_major}.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libvirtuallayerprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/PlugIns/designer/libqgis_customwidgets.$QGIS_VERSION.0.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_core.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_3d.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_analysis.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/qgis/_gui.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgis_app.$QGIS_VERSION.0.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libqgispython.$QGIS_VERSION.0.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_protobuf_lite
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libxslt
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_gis.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libzip.5.1.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/zlib.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/Resources/python/lib-dynload/binascii.cpython-37m-darwin.so

}

