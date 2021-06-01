#!/bin/bash

function check_python_pyqt5() {
  env_var_exists VERSION_python_pyqt5
}

function bundle_python_pyqt5() {
  :
}

function fix_binaries_python_pyqt5() {
  for i in \
    Qsci \
    QtBluetooth \
    QtCore \
    QtDBus \
    QtDesigner \
    QtGui \
    QtHelp \
    QtLocation \
    QtMacExtras \
    QtMultimedia \
    QtMultimediaWidgets \
    QtNetwork \
    QtNetworkAuth \
    QtNfc \
    QtOpenGL \
    QtPositioning \
    QtPrintSupport \
    QtQml \
    QtQuick \
    QtQuick3D \
    QtQuickWidgets \
    QtRemoteObjects \
    QtSensors \
    QtSerialPort \
    QtSql \
    QtSvg \
    QtTest \
    QtTextToSpeech \
    QtWebChannel \
    QtWebKit \
    QtWebKitWidgets \
    QtWebSockets \
    QtWidgets \
    QtXml \
    QtXmlPatterns \
    _QOpenGLFunctions_2_0 \
    _QOpenGLFunctions_2_1 \
    _QOpenGLFunctions_4_1_Core \
    pylupdate \
    pyrcc
  do
    PYQT5_LIB=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/$i.so
    if [ -f "$PYQT5_LIB" ]; then
      install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/$i.so
      install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/$i.so
      # for some reason "some" have it twice
      install_name_tool -delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/$i.so >/dev/null 2>&1
    else
      info "skipping pyqt5 lib $PYQT5_LIB, not present in this version of Qt/PyQt5"
    fi
  done

  install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/Qt.so
  install_name_delete_rpath /opt/QGIS/qgis-deps-${RELEASE_VERSION}/stage/lib $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/Qt.so

  install_name_change $DEPS_LIB_DIR/$LINK_libqscintilla2_qt5 @rpath/$LINK_libqscintilla2_qt5 $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/Qsci.so
}

function fix_binaries_python_pyqt5_check() {
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/PyQt5/Qt.so
}

function fix_paths_python_pyqt5() {
  :
}

function fix_paths_python_pyqt5_check() {
  :
}