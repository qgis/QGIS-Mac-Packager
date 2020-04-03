#!/bin/bash

function check_qt() {
  env_var_exists VERSION_qt
  env_var_exists QT_BASE
}

function bundle_qt() {
  QT_ROOT_DIR=$QT_BASE/clang_64

  try rsync -av $QT_ROOT_DIR/lib/QtRemoteObjects.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DInput.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWebEngineCore.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtDesigner.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtNfc.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWebEngineWidgets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtQuickWidgets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DQuickScene2D.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DRender.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtHelp.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtPrintSupport.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtGui.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtDBus.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWebSockets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtPositioningQuick.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DCore.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtLocation.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtXml.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtSerialPort.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWebView.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtQuick.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtCore.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtQml.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DExtras.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWebChannel.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtMultimedia.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtOpenGL.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWebEngine.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DQuick.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtMacExtras.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtTest.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtWidgets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtPositioning.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtBluetooth.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/Qt3DLogic.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtSql.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtConcurrent.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtSerialBus.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtGamepad.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtNetwork.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtXmlPatterns.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtSvg.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtMultimediaWidgets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtSensors.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $QT_ROOT_DIR/lib/QtTextToSpeech.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers

  # try rsync -av $QT_ROOT_DIR/lib/QtNetworkAuth.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  # try rsync -av $QT_ROOT_DIR/lib/QtVirtualKeyboard.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function postbundle_qt() {
    :
}

function add_config_info_qt() {
    :
}