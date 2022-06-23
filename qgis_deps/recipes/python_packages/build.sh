function build_python_packages() {
  try mkdir -p ${DEPS_BUILD_PATH}/python_packages/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/python_packages/build-$ARCH

  push_env

  n_packages=${#REQUIREMENTS_python_packages[@]}
  for (( ppj=0; ppj<n_packages; ppj++ )); do
    package="${REQUIREMENTS_python_packages[$ppj]}"
    if python_package_installed ${package}; then
      info "python_packages package ${package} already installed ($((ppj+1))/${n_packages})"
    else
      info "Installing python_packages package ${package} ($((ppj+1))/${n_packages})"
      # build_ext sometimes tries to dlopen the libraries
      # to determine the library version
      # this does not force --no-binary all strictly
      DYLD_LIBRARY_PATH=${STAGE_PATH}/lib try ${PIP_NO_BINARY} -v install ${package}
    fi
  done

  pop_env
}
