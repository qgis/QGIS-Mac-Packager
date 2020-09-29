#!/bin/bash

function check_qt() {
  env_var_exists VERSION_qt
  env_var_exists QT_BASE
  env_var_exists VERSION_qtextra
  env_var_exists LINK_libqsqlodbc
  env_var_exists LINK_libqsqlpsql
  env_var_exists LINK_libpq
}

function bundle_qt() {
  QT_ROOT_DIR=$QT_BASE/clang_64

  #### FRAMEWORKS
  for i in \
    QtRemoteObjects \
    Qt3DInput \
    QtDesigner \
    QtNfc \
    QtQuickWidgets \
    Qt3DQuickScene2D \
    Qt3DRender \
    QtHelp \
    QtPrintSupport \
    QtGui \
    QtDBus \
    QtWebSockets \
    QtPositioningQuick \
    Qt3DCore \
    QtLocation \
    QtXml \
    QtSerialPort \
    QtWebView \
    QtQuick \
    QtCore \
    QtQml \
    Qt3DExtras \
    QtWebChannel \
    QtMultimedia \
    QtOpenGL \
    Qt3DQuick \
    QtMacExtras \
    QtTest \
    QtWidgets \
    QtPositioning \
    QtBluetooth \
    Qt3DLogic \
    QtSql \
    QtConcurrent \
    QtSerialBus \
    QtGamepad \
    QtNetwork \
    QtXmlPatterns \
    QtSvg \
    QtMultimediaWidgets \
    QtSensors \
    QtTextToSpeech \
    QtQmlModels \
    QtDesignerComponents
  do
    try rsync -av $QT_ROOT_DIR/lib/$i.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  done

  #### PLUGINS
  try rsync -av $QT_ROOT_DIR/plugins/* $BUNDLE_PLUGINS_DIR/

  # we build sqldrivers ourselves, see qgis_deps/recipes/qtextra/recipe.sh
  # https://bugreports.qt.io/browse/QTBUG-85369
  try rm $BUNDLE_PLUGINS_DIR/sqldrivers/*
  try cp -av $QT_ROOT_DIR/plugins/sqldrivers/libqsqlite.dylib $BUNDLE_PLUGINS_DIR/sqldrivers/
  try cp -av ${STAGE_PATH}/qt5/plugins/sqldrivers/* $BUNDLE_PLUGINS_DIR/sqldrivers/

  #### Designer
  try rsync -av $QT_ROOT_DIR/bin/Designer.app $BUNDLE_MACOS_DIR/
  try cp -av $RECIPES_PATH/qt/designer $BUNDLE_BIN_DIR/
}

function fix_binaries_qt() {
  install_name_add_rpath @executable_path/../../../../Frameworks $BUNDLE_CONTENTS_DIR/MacOS/Designer.app/Contents/MacOS/Designer

  install_name_change $DEPS_LIB_DIR/$LINK_libpq @rpath/$LINK_libpq $BUNDLE_PLUGINS_DIR/sqldrivers/$LINK_libqsqlpsql
  install_name_add_rpath @loader_path/../../MacOS/lib $BUNDLE_PLUGINS_DIR/sqldrivers/$LINK_libqsqlpsql
  install_name_add_rpath @loader_path/../../Frameworks $BUNDLE_PLUGINS_DIR/sqldrivers/$LINK_libqsqlpsql

  install_name_change $QGIS_DEPS_STAGE_PATH/unixodbc/lib/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_PLUGINS_DIR/sqldrivers/$LINK_libqsqlodbc
  install_name_add_rpath @loader_path/../../MacOS/lib $BUNDLE_PLUGINS_DIR/sqldrivers/$LINK_libqsqlodbc
  install_name_add_rpath @loader_path/../../Frameworks $BUNDLE_PLUGINS_DIR/sqldrivers/$LINK_libqsqlodbc
}

function fix_binaries_qt_check() {
  verify_binary $BUNDLE_CONTENTS_DIR/MacOS/Designer.app/Contents/MacOS/Designer
}

function fix_paths_qt() {
  :
}

function fix_paths_qt_check() {
  :
}
