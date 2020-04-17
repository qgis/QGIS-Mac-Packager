#!/bin/bash

function check_jpeg() {
  env_var_exists VERSION_jpeg
  env_var_exists LINK_jpeg
}

function bundle_jpeg() {
  try cp -av $DEPS_LIB_DIR/libjpeg.*dylib $BUNDLE_LIB_DIR
}

function postbundle_jpeg() {
 install_name_id  @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_jpeg

 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal

 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_jpeg @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib
}

function add_config_info_jpeg() {
    :
}
