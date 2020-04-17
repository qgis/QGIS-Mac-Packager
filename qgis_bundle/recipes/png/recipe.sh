#!/bin/bash

function check_png() {
  env_var_exists VERSION_png
}

function bundle_png() {
    try cp -av $DEPS_LIB_DIR/libpng*dylib $BUNDLE_LIB_DIR
}

function postbundle_png() {
 install_name_id @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libpng16.16.dylib

 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgrass_pngdriver.7.8.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib

 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libpng16.16.dylib @rpath/libpng16.16.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-3.0.0.4.0.dylib
}

function add_config_info_png() {
    :
}
