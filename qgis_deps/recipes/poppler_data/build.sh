function build_poppler_data() {
  rsync -a ${BUILD_poppler_data}/ ${DEPS_BUILD_PATH}/poppler_data/build-${ARCH}/
  cd ${DEPS_BUILD_PATH}/poppler_data/build-${ARCH}
  push_env
  ${MAKESMP} install prefix=${STAGE_PATH}
  pop_env
}
