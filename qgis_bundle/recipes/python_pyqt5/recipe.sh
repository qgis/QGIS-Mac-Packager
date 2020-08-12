#!/bin/bash

function check_python_pyqt5() {
  env_var_exists VERSION_python_pyqt5
}

function bundle_python_pyqt5() {
  :
}

function postbundle_python_pyqt5() {
  for i in \
    QtPrintSupport \
    QtPositioning \
    QtXml \
    QtHelp \
    QtQuickWidgets \
    QtWebKitWidgets \
    QtWebKit \
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
    install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/$i.so

    # for some reason "some" have it twice
    install_name_tool -delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/$i.so >/dev/null 2>&1
  done

  install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/Qt.so
  install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/Qt.so

  install_name_change $DEPS_LIB_DIR/$LINK_libqscintilla2_qt5 @rpath/$LINK_libqscintilla2_qt5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/Qsci.so
}

