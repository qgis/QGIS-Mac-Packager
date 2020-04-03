#!/bin/bash

function check_qgis() {
  env_var_exists VERSION_qgis
  env_var_exists QGIS_INSTALL_DIR
}

function bundle_qgis() {
  QGIS_CONTENTS_DIR=$QGIS_INSTALL_DIR/QGIS.app/Contents/

  try cp -av $QGIS_CONTENTS_DIR/Info.plist $BUNDLE_CONTENTS_DIR
  try cp -av $QGIS_CONTENTS_DIR/PkgInfo $BUNDLE_CONTENTS_DIR

  try cp -av $QGIS_CONTENTS_DIR/MacOS/QGIS $BUNDLE_MACOS_DIR

  try cp -av $QGIS_CONTENTS_DIR/MacOS/lib/libqgis_app.* $BUNDLE_LIB_DIR
  try cp -av $QGIS_CONTENTS_DIR/MacOS/lib/libqgispython.* $BUNDLE_LIB_DIR

  try rsync -av $QGIS_CONTENTS_DIR/PlugIns/ $BUNDLE_PLUGINS_DIR/
  try rsync -av $QGIS_CONTENTS_DIR/Resources/ $BUNDLE_RESOURCES_DIR/

  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_analysis.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Header
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_core.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_gui.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgis_native.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QGIS_CONTENTS_DIR/Frameworks/qgisgrass7.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function postbundle_qgis() {
    : # install_name_tool -id "@rpath/libqgis.dylib" ${STAGE_PATH}/lib/libqgis.dylib
}

function add_config_info_qgis() {
    :
}
