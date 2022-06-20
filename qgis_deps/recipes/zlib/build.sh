function build_zlib() {
  try cd ${DEPS_BUILD_PATH}/zlib/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  try install_name_tool -id ${STAGE_PATH}/lib/$LINK_zlib ${STAGE_PATH}/lib/$LINK_zlib

  pop_env
}
