function build_python_qscintilla() {
  try cd ${DEPS_BUILD_PATH}/python_qscintilla/build-$ARCH
  push_env


  #mkdir -p ${STAGE_PATH}/share/sip/PyQt5/Qsci

  try cp pyproject-qt5.toml  pyproject.toml

  try ${STAGE_PATH}/bin/sip-install --verbose --qsci-include-dir "${STAGE_PATH}/include" --qsci-features-dir "${STAGE_PATH}/data/mkspecs/features" --qsci-library-dir "${STAGE_PATH}/lib"

  install_name_tool -add_rpath "${STAGE_PATH}/lib" $QGIS_SITE_PACKAGES_PATH/PyQt5/Qsci.so

  pop_env
}
