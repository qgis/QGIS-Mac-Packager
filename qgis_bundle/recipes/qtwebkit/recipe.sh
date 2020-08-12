#!/bin/bash

function check_qtwebkit() {
  env_var_exists VERSION_qtwebkit
}

function bundle_qtwebkit() {
  try rsync -av $DEPS_LIB_DIR/QtWebKitWidgets.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
  try rsync -av $DEPS_LIB_DIR/QtWebKit.framework $BUNDLE_FRAMEWORKS_DIR/ --exclude Headers
}

function postbundle_qtwebkit() {
  install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKitWidgets.framework/Versions/5/QtWebKitWidgets
  install_name_delete_rpath $QT_BASE/clang_64/lib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit

  install_name_delete_rpath $ROOT_OUT_PATH/build/qtwebkit/build-x86_64/lib $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKitWidgets.framework/Versions/5/QtWebKitWidgets

  install_name_add_rpath @executable_path/../Frameworks $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKitWidgets.framework/Versions/5/QtWebKitWidgets
  install_name_add_rpath @loader_path/Frameworks $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKitWidgets.framework/Versions/5/QtWebKitWidgets

  install_name_add_rpath @executable_path/../Frameworks $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
  install_name_add_rpath @loader_path/Frameworks $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit

  for i in \
    $LINK_jpeg \
    $LINK_libpng \
    $LINK_libwebp \
    $LINK_zlib \
    $LINK_libxml2 \
    $LINK_libxslt \
    $LINK_sqlite
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_CONTENTS_DIR/Frameworks/QtWebKit.framework/Versions/5/QtWebKit
  done
}