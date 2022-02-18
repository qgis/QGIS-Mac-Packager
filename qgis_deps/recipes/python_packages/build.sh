function build_python_packages() {
  try mkdir -p ${DEPS_BUILD_PATH}/python_packages/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/python_packages/build-$ARCH

  push_env

  for i in ${REQUIREMENTS_python_packages[*]}
  do
    info "Installing python_packages package $i"
    # build_ext sometimes tries to dlopen the libraries
    # to determine the library version
    # this does not force --no-binary all strictly
    DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY install $i
  done

  pop_env
}
