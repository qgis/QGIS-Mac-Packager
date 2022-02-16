function build_python_rtree() {
  try cd $BUILD_PATH/python_rtree/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  # see https://github.com/qgis/QGIS-Mac-Packager/issues/80
  cd $STAGE_PATH/lib/python${VERSION_major_python}/site-packages/Rtree-${VERSION_python_rtree}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg/rtree
  if [ -f _core.py ]; then
    info "python_rtree core.py already patched"
  else
    info "patching core.py for python_rtree"
    try mv core.py _core.py
    try cp $RECIPE_python_rtree/core.py core.py
  fi

  pop_env
}
