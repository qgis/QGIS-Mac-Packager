#!/bin/bash

function check_hdf5() {
  env_var_exists VERSION_hdf5
  env_var_exists LINK_libhdf5
}

function bundle_hdf5() {
    try cp -av $DEPS_LIB_DIR/libhdf5.*dylib $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libhdf5_hl.*dylib $BUNDLE_LIB_DIR
}

function postbundle_hdf5() {

 install_name_id @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5
 install_name_id @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5_hl

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/PlugIns/qgis/libmdalprovider.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_netcdf
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/defs.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_proxy.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5fd.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5f.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5ds.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5l.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5d.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5s.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/utils.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_objects.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5g.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5o.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_errors.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5t.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_conv.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5z.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5r.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5i.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5ac.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5a.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5pl.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5p.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libhdf5_hl
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5 @rpath/$LINK_libhdf5 $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so

 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_netcdf
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/defs.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_proxy.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5fd.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5f.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5ds.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5l.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5d.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5s.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/utils.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_objects.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5g.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5o.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_errors.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5t.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/_conv.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5z.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5r.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5i.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5ac.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5a.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5pl.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/h5py/h5p.cpython-37m-darwin.so
 install_name_change $DEPS_LIB_DIR/$LINK_libhdf5_hl @rpath/$LINK_libhdf5_hl $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/netCDF4-$VERSION_python_netcdf4-py$VERSION_major_python-macosx-$MACOSX_DEPLOYMENT_TARGET-x86_64.egg/netCDF4/_netCDF4.cpython-${VERSION_major_python//./}m-darwin.so
}
