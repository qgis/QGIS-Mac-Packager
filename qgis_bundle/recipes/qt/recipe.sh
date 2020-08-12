#!/bin/bash

function check_qt() {
  env_var_exists VERSION_qt
  env_var_exists QT_BASE
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

  # https://bugreports.qt.io/browse/QTBUG-85369
  try rm $BUNDLE_PLUGINS_DIR/sqldrivers/libqsqlpsql.dylib
  try rm $BUNDLE_PLUGINS_DIR/sqldrivers/libqsqlodbc.dylib

  #### Designer
  try rsync -av $QT_ROOT_DIR/bin/Designer.app $BUNDLE_MACOS_DIR/
}

function postbundle_qt() {
  install_name_add_rpath @executable_path/../../../../Frameworks $BUNDLE_CONTENTS_DIR/MacOS/Designer.app/Contents/MacOS/Designer
}

