function build_freetds() {
  try cd ${DEPS_BUILD_PATH}/freetds/build-$ARCH
  push_env

  # add unixodbc
  export CFLAGS="$CFLAGS -I$STAGE_PATH/unixodbc/include"
  export LDFLAGS="$LDFLAGS -L$STAGE_PATH/unixodbc/lib"

  try ${CONFIGURE} \
      --with-tdsver=7.3 \
      --mandir=${STAGE_PATH}/man \
      --sysconfdir=${STAGE_PATH}/etc \
      --with-unixodbc-includes=${STAGE_PATH}/include/unixodbc \
      --with-openssl=${STAGE_PATH} \
      --enable-sybase-compat \
      --enable-krb5 \
      --enable-odbc-wide

  check_file_configuration config.status
  try $MAKE
  try $MAKE install

  # add freetds to unixodbc file
  UNIXODB_INI=$STAGE_PATH/unixodbc/etc/odbcinst.ini
  if ! grep -q FreeTDS "$UNIXODB_INI"; then
    echo "Patching $UNIXODB_INI with FreeTDS driver"
    echo "[FreeTDS]" >> $UNIXODB_INI
    echo "Description = FreeTDS Driver" >> $UNIXODB_INI
    echo "Driver = $STAGE_PATH/lib/libtdsodbc.so" >> $UNIXODB_INI
  fi
  pop_env
}
