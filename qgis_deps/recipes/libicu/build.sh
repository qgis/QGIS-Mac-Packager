function build_libicu() {
  try cd ${DEPS_BUILD_PATH}/libicu/build-$ARCH/icu4c/source
  push_env

  try ./runConfigureICU MacOSX --prefix=${STAGE_PATH} --enable-rpath \
    --disable-samples \
    --disable-extras \
    --disable-layout \
    --disable-tests \
    --with-data-packaging=library

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  # not sure why, but the original file seems corrupted after installtion
  cp ${DEPS_BUILD_PATH}/libicu/build-x86_64/icu4c/source/lib/libicudata.${VERSION_libicu}.dylib ${STAGE_PATH}/lib/libicudata.${VERSION_libicu}.dylib

  targets=(
    libicudata.${VERSION_libicu}.dylib
    libicui18n.${VERSION_libicu}.dylib
    libicuio.${VERSION_libicu}.dylib
    libicutu.${VERSION_libicu}.dylib
    libicuuc.${VERSION_libicu}.dylib
  )
  for i in ${targets[*]}
  do
    info install_name_tool -id $STAGE_PATH/lib/$i $STAGE_PATH/lib/$i
    try install_name_tool -id $STAGE_PATH/lib/$i $STAGE_PATH/lib/$i
    for j in ${targets[*]}
    do
      info install_name_tool -change $j $STAGE_PATH/lib/$j $STAGE_PATH/lib/$i
      try install_name_tool -change $j $STAGE_PATH/lib/$j $STAGE_PATH/lib/$i
    done
  done

  pop_env
}
