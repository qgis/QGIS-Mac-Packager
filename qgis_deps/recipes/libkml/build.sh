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

  for i in \
    $LINK_libkmlbase \
    $LINK_libkmlconvenience \
    $LINK_libkmldom \
    $LINK_libkmlengine \
    $LINK_libkmlregionator \
    $LINK_libkmlxsd
  do
    install_name_tool -id $STAGE_PATH/lib/$i $STAGE_PATH/lib/$i
    for j in \
        $LINK_libkmlbase \
        $LINK_libkmlconvenience \
        $LINK_libkmldom \
        $LINK_libkmlengine \
        $LINK_libkmlregionator \
        $LINK_libkmlxsd
    do
      install_name_tool -change ${DEPS_BUILD_PATH}/libkml/build-$ARCH/lib/$j $STAGE_PATH/lib/$j $STAGE_PATH/lib/$i
    done
  done

  pop_env
}
