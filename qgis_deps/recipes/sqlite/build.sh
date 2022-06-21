function build_sqlite() {
  try cd ${DEPS_BUILD_PATH}/sqlite/build-$ARCH
  push_env

  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
  export CPPFLAGS="$CPPFLAGS -DSQLITE_MAX_VARIABLE_NUMBER=250000"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_RTREE=1"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_FTS3=1"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_JSON1=1"
  export CPPFLAGS="$CPPFLAGS -DSQLITE_ENABLE_SESSION=1"

  try ${CONFIGURE} \
    --disable-debug \
    --disable-dependency-tracking \
    --enable-dynamic-extensions \
    --enable-readline \
    --disable-editline \
    --enable-static=no \
    --enable-shared=yes \
    --enable-session

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install

  pop_env
}
