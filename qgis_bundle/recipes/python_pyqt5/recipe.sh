#!/bin/bash

function check_python_pyqt5() {
  env_var_exists VERSION_python_pyqt5
}

function bundle_python_pyqt5() {
  :
}

function postbundle_python_pyqt5() {
  install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/Qsci.so

  for i in \
    QtPrintSupport \
    QtPositioning \
    QtXml \
    QtHelp \
    QtQuickWidgets \
    QtMultimediaWidgets \
    QtNfc \
    QtQuick \
    QtNetwork \
    _QOpenGLFunctions_4_1_Core \
    QtWebChannel \
    _QOpenGLFunctions_2_0 \
    QtMultimedia \
    _QOpenGLFunctions_2_1 \
    Qsci \
    QtWidgets \
    QtBluetooth \
    QtGui \
    QtDBus \
    QtSql \
    QtTest \
    QtLocation \
    QtDesigner \
    QtQml \
    QtOpenGL \
    pylupdate \
    QtCore \
    QtRemoteObjects \
    QtSensors \
    QtWebSockets \
    QtXmlPatterns \
    QtMacExtras \
    QtSerialPort \
    QtSvg \
    pyrcc
  do
    install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/$i.so
  done
}

