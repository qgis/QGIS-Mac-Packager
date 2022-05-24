function build_hdf5() {
  try mkdir -p ${DEPS_BUILD_PATH}/hdf5/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/hdf5/build-$ARCH
  push_env

  try $CMAKE \
    -DBUILD_STATIC_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DHDF5_BUILD_CPP_LIB=ON \
    $BUILD_hdf5 .

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id ${STAGE_PATH}/lib/${LINK_libhdf5} ${STAGE_PATH}/lib/${LINK_libhdf5}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5}

  install_name_tool -id ${STAGE_PATH}/lib/${LINK_libhdf5_cpp} ${STAGE_PATH}/lib/${LINK_libhdf5_cpp}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5_cpp}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5_cpp} $STAGE_PATH/lib/${LINK_libhdf5_cpp} $STAGE_PATH/lib/${LINK_libhdf5_cpp}

  install_name_tool -id ${STAGE_PATH}/lib/${LINK_libhdf5_hl} ${STAGE_PATH}/lib/${LINK_libhdf5_hl}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5_hl}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5_hl} $STAGE_PATH/lib/${LINK_libhdf5_hl} $STAGE_PATH/lib/${LINK_libhdf5_hl}

  install_name_tool -id ${STAGE_PATH}/lib/${LINK_libhdf5_hl_cpp} ${STAGE_PATH}/lib/${LINK_libhdf5_hl_cpp}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5} $STAGE_PATH/lib/${LINK_libhdf5_hl_cpp}
  install_name_tool -change ${DEPS_BUILD_PATH}/hdf5/build-$ARCH/${LINK_libhdf5_hl_cpp} $STAGE_PATH/lib/${LINK_libhdf5_hl_cpp} $STAGE_PATH/lib/${LINK_libhdf5_hl_cpp}

  pop_env
}
