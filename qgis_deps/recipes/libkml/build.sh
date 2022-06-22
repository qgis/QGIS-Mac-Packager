function build_libkml() {
  try mkdir -p ${DEPS_BUILD_PATH}/libkml/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/libkml/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBoost_DIR=${STAGE_PATH}/boost \
    -DBoost_INCLUDE_DIR=${STAGE_PATH}/include \
    $BUILD_libkml

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  for lki in \
    $LINK_libkmlbase \
    $LINK_libkmlconvenience \
    $LINK_libkmldom \
    $LINK_libkmlengine \
    $LINK_libkmlregionator \
    $LINK_libkmlxsd
  do
    install_name_tool -id $STAGE_PATH/lib/$lki $STAGE_PATH/lib/$lki
    for lkj in \
        $LINK_libkmlbase \
        $LINK_libkmlconvenience \
        $LINK_libkmldom \
        $LINK_libkmlengine \
        $LINK_libkmlregionator \
        $LINK_libkmlxsd
    do
      install_name_tool -change ${DEPS_BUILD_PATH}/libkml/build-$ARCH/lib/$lkj $STAGE_PATH/lib/$lkj $STAGE_PATH/lib/$lki
    done
  done

  pop_env
}
