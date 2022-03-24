function build_python_packages() {
  try mkdir -p ${DEPS_BUILD_PATH}/python_packages/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/python_packages/build-$ARCH

  push_env

  n_packages=${#REQUIREMENTS_python_packages[@]}
  for (( j=0; j<n_packages; j++ )); do
    package="${REQUIREMENTS_python_packages[$j]}"
    info "Installing python_packages package ${package} ($((j+1))/${n_packages})"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    # this does not force --no-binary all strictly
    DYLD_LIBRARY_PATH=${STAGE_PATH}/lib try ${PIP_NO_BINARY} -v install ${package}
  done

  pop_env
}
