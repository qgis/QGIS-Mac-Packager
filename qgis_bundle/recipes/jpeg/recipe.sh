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

 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libtiff.5.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib

 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib
 install_name_change $DEPS_LIB_DIR/libjpeg.9.dylib @rpath/libjpeg.9.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-3.0.0.4.0.dylib
}

function add_config_info_jpeg() {
    :
}
