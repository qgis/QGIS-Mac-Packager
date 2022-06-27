function build_python_psycopg2() {
  try mkdir -p $BUILD_python_psycopg2
  try cd $BUILD_python_psycopg2
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY psycopg2==${VERSION_python_psycopg2}

  pop_env
}
