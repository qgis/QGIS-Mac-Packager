#!/bin/bash

function check_wxmac() {
  env_var_exists VERSION_wxmac
  env_var_exists VERSION_wxmac_major
}

function bundle_wxmac() {
   try cp -av $DEPS_LIB_DIR/libwx_*dylib $BUNDLE_LIB_DIR

}

function postbundle_wxmac() {
    install_name_id @rpath/libwx_baseu.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_baseu_net.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_baseu_xml.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_adv.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_aui.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_core.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_gl.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_html.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_media.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_propgrid.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_qa.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_ribbon.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_richtext.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_stc.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
    install_name_id @rpath/libwx_osx_cocoau_xrc.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_baseu-${VERSION_wxmac_major}.dylib @rpath/libwx_baseu-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu-${LINK_wxmac_version}.dylib @rpath/libwx_baseu-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_baseu_net-${VERSION_wxmac_major}.dylib @rpath/libwx_baseu_net-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_baseu_xml-${VERSION_wxmac_major}.dylib @rpath/libwx_baseu_xml-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_baseu_xml-${LINK_wxmac_version}.dylib @rpath/libwx_baseu_xml-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu_xml-${LINK_wxmac_version}.dylib @rpath/libwx_baseu_xml-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_baseu_xml-${LINK_wxmac_version}.dylib @rpath/libwx_baseu_xml-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_adv-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_aui-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_aui-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_core-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib

  install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_html-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_html-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib @rpath/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/libwx_osx_cocoau_qa-${VERSION_wxmac_major}.dylib @rpath/libwx_osx_cocoau_qa-${VERSION_wxmac_major}.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib

 install_name_change $DEPS_LIB_DIR/$LINK_expat @rpath/$LINK_expat $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-${LINK_wxmac_version}.dylib

  install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib
 install_name_change $DEPS_LIB_DIR/$LINK_libtiff @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib

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
}
