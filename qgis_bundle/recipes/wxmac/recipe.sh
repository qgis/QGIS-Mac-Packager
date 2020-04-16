#!/bin/bash

function check_wxmac() {
  env_var_exists VERSION_wxmac
}

function bundle_wxmac() {
   try cp -av $DEPS_LIB_DIR/libwx_*dylib $BUNDLE_LIB_DIR

}

function postbundle_wxmac() {
    install_name_id @rpath/libwx_baseu.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_baseu_net.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_baseu_xml.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_adv.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_aui.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_core.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_gl.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_html.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_media.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_propgrid.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_qa.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_ribbon.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_richtext.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_stc.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-3.0.0.4.0.dylib
    install_name_id @rpath/libwx_osx_cocoau_xrc.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib

  install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.dylib @rpath/libwx_baseu-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/bin/saga_cmd
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.dylib @rpath/libwx_baseu-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.dylib @rpath/libwx_baseu-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.dylib @rpath/libwx_baseu-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.dylib @rpath/libwx_baseu-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.dylib @rpath/libwx_baseu-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libsaga_api-7.3.0.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu-3.0.0.4.0.dylib @rpath/libwx_baseu-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-3.0.0.4.0.dylib

  install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_net-3.0.dylib @rpath/libwx_baseu_net-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/bin/saga_cmd
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_net-3.0.dylib @rpath/libwx_baseu_net-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_net-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_net-3.0.dylib @rpath/libwx_baseu_net-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_net-3.0.dylib @rpath/libwx_baseu_net-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_net-3.0.dylib @rpath/libwx_baseu_net-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_net-3.0.dylib @rpath/libwx_baseu_net-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libsaga_api-7.3.0.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.dylib @rpath/libwx_baseu_xml-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/bin/saga_cmd
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.dylib @rpath/libwx_baseu_xml-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.dylib @rpath/libwx_baseu_xml-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.dylib @rpath/libwx_baseu_xml-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.dylib @rpath/libwx_baseu_xml-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_baseu_xml-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.dylib @rpath/libwx_baseu_xml-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libsaga_api-7.3.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.0.4.0.dylib @rpath/libwx_baseu_xml-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.0.4.0.dylib @rpath/libwx_baseu_xml-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_baseu_xml-3.0.0.4.0.dylib @rpath/libwx_baseu_xml-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib

  install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_adv-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib


 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_aui-3.0.dylib @rpath/libwx_osx_cocoau_aui-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.dylib @rpath/libwx_osx_cocoau_core-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.dylib @rpath/libwx_osx_cocoau_core-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.dylib @rpath/libwx_osx_cocoau_core-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.dylib @rpath/libwx_osx_cocoau_core-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib

  install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_gl-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_aui-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_stc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_ribbon-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_adv-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_propgrid-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_core-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_core-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_media-3.0.0.4.0.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.dylib @rpath/libwx_osx_cocoau_html-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/bin/saga_cmd
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.dylib @rpath/libwx_osx_cocoau_html-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.dylib @rpath/libwx_osx_cocoau_html-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.dylib @rpath/libwx_osx_cocoau_html-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.dylib @rpath/libwx_osx_cocoau_html-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.dylib @rpath/libwx_osx_cocoau_html-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libsaga_api-7.3.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_html-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_xrc-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_html-3.0.0.4.0.dylib @rpath/libwx_osx_cocoau_html-3.0.0.4.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_richtext-3.0.0.4.0.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_xrc-3.0.dylib @rpath/libwx_osx_cocoau_xrc-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_xrc-3.0.dylib @rpath/libwx_osx_cocoau_xrc-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_xrc-3.0.dylib @rpath/libwx_osx_cocoau_xrc-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib

 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_qa-3.0.dylib @rpath/libwx_osx_cocoau_qa-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libwx_osx_cocoau_qa-3.0.0.4.0.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_qa-3.0.dylib @rpath/libwx_osx_cocoau_qa-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libpointcloud_tools.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_qa-3.0.dylib @rpath/libwx_osx_cocoau_qa-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_shapes.dylib
 install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libwx_osx_cocoau_qa-3.0.dylib @rpath/libwx_osx_cocoau_qa-3.0.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/saga/libio_virtual.dylib
}

function add_config_info_wxmac() {
    :
}

