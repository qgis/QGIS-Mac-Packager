#!/bin/bash

function check_python_opencv() {
  env_var_exists VERSION_python_opencv
}

function bundle_python_opencv() {
  :
}

function postbundle_python_opencv() {
 # TODO why MACOS_TARGET 10.9 and not 10.13??
 OPENCV_EGG=$BUNDLE_CONTENTS_DIR/Resources/python/site-packages/opencv_contrib_python-${VERSION_python_opencv}-py${VERSION_major_python}-macosx-10.9-x86_64.egg

 install_name_id @rpath/libqcocoa.dylib $OPENCV_EGG/cv2/qt/plugins/platforms/libqcocoa.dylib

 # TODO Why /usr/local/opt/qt/plugins/platforms/libqcocoa.dylib is linked .. -> fix in qgis_deps!
 install_name_change /usr/local/opt/qt/plugins/platforms/libqcocoa.dylib @rpath/libqcocoa.dylib $OPENCV_EGG/cv2/qt/plugins/platforms/libqcocoa.dylib
}

