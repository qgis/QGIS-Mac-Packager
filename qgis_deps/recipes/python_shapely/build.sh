function build_python_shapely() {
  mkdir -p $BUILD_python_shapely
  try cd $BUILD_python_shapely
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib; GEOS_CONFIG=$STAGE_PATH/bin/geos-config; try $PIP_NO_BINARY shapely==${VERSION_python_shapely}

  cd $STAGE_PATH/lib/python${VERSION_major_python}/site-packages/shapely
  if [ -f _geos.py ]; then
    info "python_shapely geos.py already patched"
  else
    info "patching geos.py for python_shapely"
    try mv geos.py _geos.py
    try cp $RECIPE_python_shapely/geos.py geos.py

    # fix when loading geopandas
    # OSError: Could not find lib c or load any of its variants free from _geos.py
    try ${SED} "s;load_dll('c');load_dll('c', fallbacks=['/usr/lib/libc.dylib']);g" _geos.py
  fi

  pop_env
}
