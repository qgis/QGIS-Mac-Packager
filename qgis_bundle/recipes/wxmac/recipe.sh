#!/bin/bash

function check_wxmac() {
  env_var_exists VERSION_wxmac
}

function bundle_wxmac() {
    : # install_name_tool -id "@rpath/libwxmac.dylib" ${STAGE_PATH}/lib/libwxmac.dylib
}

function postbundle_wxmac() {
    :
}

function add_config_info_wxmac() {
    :
}

patch_wxmac_linker_links () {
  install_name_tool -id "@rpath/libwx_baseu_net-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_baseu_net.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_gl.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_aui.dylib
  install_name_tool -id "@rpath/libwx_baseu-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_baseu.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_qa.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_xrc.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_stc.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_ribbon.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_core.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_adv.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_html.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_propgrid.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_richtext.dylib
  install_name_tool -id "@rpath/libwx_baseu_xml-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_baseu_xml.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_media.dylib
}
