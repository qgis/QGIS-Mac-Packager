#!/bin/bash

function check_python_pillow() {
  env_var_exists VERSION_python_pillow
}

function bundle_python_pillow() {
  # the pillow.egg is zip file, unzip it to be able to fix binaries
  cd $BUNDLE_PYTHON_SITE_PACKAGES_DIR

  try unzip pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg -d _tmp_pillow
  try rm -rf pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
  try mv _tmp_pillow pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
}

function fix_binaries_python_pillow() {
  pillow_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    _imaging.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingcms.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingft.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingmath.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingmorph.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingtk.cpython-${VERSION_major_python//./}m-darwin.so \
    _webp.cpython-${VERSION_major_python//./}m-darwin.so
  do
    install_name_id @rpath/$i $pillow_EGG/PIL/$i
  done

  for j in \
      $LINK_jpeg \
      $LINK_openjpeg \
      $LINK_zlib \
      $LINK_libtiff
  do
    install_name_change $DEPS_LIB_DIR/$j @rpath/$j $pillow_EGG/PIL/_imaging.cpython-${VERSION_major_python//./}m-darwin.so
  done

  install_name_change $DEPS_LIB_DIR/$LINK_little_cms2 @rpath/$LINK_little_cms2 $pillow_EGG/PIL/_imagingcms.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_freetype @rpath/$LINK_freetype $pillow_EGG/PIL/_imagingft.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libwebp @rpath/$LINK_libwebp $pillow_EGG/PIL/_webp.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_binaries_python_pillow_check() {
  pillow_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/pillow-${VERSION_python_pillow}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg

  for i in \
    _imaging.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingcms.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingft.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingmath.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingmorph.cpython-${VERSION_major_python//./}m-darwin.so \
    _imagingtk.cpython-${VERSION_major_python//./}m-darwin.so \
    _webp.cpython-${VERSION_major_python//./}m-darwin.so
  do
    verify_binary $pillow_EGG/PIL/$i
  done
}

function fix_paths_python_pillow() {
  :
}

function fix_paths_python_pillow_check() {
  :
}