#!/bin/bash

function check_png() {
  env_var_exists VERSION_png
}

function bundle_png() {
    try cp -av $DEPS_LIB_DIR/libpng*dylib $BUNDLE_LIB_DIR
}

function postbundle_png() {
 install_name_id @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libpng

 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.${VERSION_grass_major}.${VERSION_grass_minor}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libpng @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib
}

function add_config_info_png() {
    :
}
