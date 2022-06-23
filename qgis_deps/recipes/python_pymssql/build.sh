function build_python_pymssql() {
  mkdir -p $BUILD_python_pymssql
  try cd $BUILD_python_pymssql
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY pymssql==${VERSION_python_pymssql}

  pop_env
}
