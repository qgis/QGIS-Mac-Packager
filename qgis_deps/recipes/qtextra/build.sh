function build_qtextra() {
  try cd $BUILD_PATH/qtextra/build-$ARCH
  push_env

  # Check https://doc.qt.io/qt-5/sql-driver.html for available drivers
  # sqlite3 is already shipped with Qt
  # note that the plugins will not be useful in developer mode (building QGIS)
  # , since they are not in <QT>/clang_64/plugins directory.
  # make a symbolic link if you want to use it in the dev mode
  try mkdir -p ${STAGE_PATH}/qt5/plugins/sqldrivers

  cd src/plugins/sqldrivers/
  try ${SED} 's;-liodbc;-lodbc;g' configure.json
  rm -f config.cache

  try ${QMAKE} -- \
    ODBC_PREFIX=$STAGE_PATH/unixodbc \
    PSQL_INCDIR=$STAGE_PATH/include \
    PSQL_LIBDIR=$STAGE_PATH/lib

  try $MAKE sub-odbc
  try cp plugins/sqldrivers/libqsqlodbc.dylib ${STAGE_PATH}/qt5/plugins/sqldrivers/

  try $MAKESMP sub-psql
  try cp plugins/sqldrivers/libqsqlpsql.dylib ${STAGE_PATH}/qt5/plugins/sqldrivers/

  pop_env
}
