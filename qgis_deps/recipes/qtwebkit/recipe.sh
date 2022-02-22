#!/bin/bash

DESC_qtwebkit="WebKit extension for QT5"


DEPS_qtwebkit=( sqlite bison webp zlib libxslt jpeg png libtiff libicu )


# md5 of the package

# default build path
BUILD_qtwebkit=${DEPS_BUILD_PATH}/qtwebkit/$(get_directory $URL_qtwebkit)

# default recipe path
RECIPE_qtwebkit=$RECIPES_PATH/qtwebkit

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtwebkit() {
  cd $BUILD_qtwebkit


  #https://github.com/qtwebkit/qtwebkit/pull/1012/files
  try patch --verbose --forward -p1 < $RECIPE_qtwebkit/patches/bison37.patch

  # Ambiguous Handle (also in MacPorts.h)
  try ${SED} 's;isReachableFromOpaqueRoots(Handle<JSC::Unknown>;isReachableFromOpaqueRoots(JSC::Handle<JSC::Unknown>;g' Source/JavaScriptCore/jsc.cpp

}

function shouldbuild_qtwebkit() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/qml/QtWebKit/libqmlwebkitplugin.so -nt $BUILD_qtwebkit/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_qtwebkit() {
  verify_binary lib/qml/QtWebKit/experimental/libqmlwebkitexperimentalplugin.so
  verify_binary lib/qml/QtWebKit/libqmlwebkitplugin.so
}

# function to append information to config file
function add_config_info_qtwebkit() {
  append_to_config_file "# qtwebkit-${VERSION_qtwebkit}: ${DESC_qtwebkit}"
  append_to_config_file "export VERSION_qtwebkit=${VERSION_qtwebkit}"
}