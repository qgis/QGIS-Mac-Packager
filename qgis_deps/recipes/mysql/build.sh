function build_mysql() {
  try mkdir -p ${DEPS_BUILD_PATH}/mysql/build-$ARCH
  try cd ${DEPS_BUILD_PATH}/mysql/build-$ARCH
  try mkdir -p downloaded_boost
  push_env

  # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
  try ${CMAKE}  \
      -DWITHOUT_SERVER=ON \
      -DFORCE_INSOURCE_BUILD=1 \
      -DENABLED_PROFILING=OFF \
      -DCOMPILATION_COMMENT=qgis_deps \
      -DINSTALL_DOCDIR=share/doc/mysql \
      -DINSTALL_INCLUDEDIR=include/mysql \
      -DINSTALL_INFODIR=share/info \
      -DINSTALL_MANDIR=share/man \
      -DINSTALL_MYSQLSHAREDIR=share/mysql \
      -DINSTALL_SUPPORTFILESDIR=mysql/support-files \
      -DINSTALL_PLUGINDIR=lib/plugin \
      -DMYSQL_DATADIR=$STAGE_PATH/share/data \
      -DDOWNLOAD_BOOST=OFF \
      -DWITH_BOOST=system \
      -DWITH_PROTOBUF=system \
      -DWITH_CURL=system \
      -DWITH_ZSTD=system \
      -DWITH_SYSTEM_LIBS_DEFAULT=TRUE \
      -DCMAKE_FIND_FRAMEWORK=LAST \
      -DWITH_EDITLINE=system \
      -DWITH_SSL=$STAGE_PATH \
      -DWITH_UNIT_TESTS=OFF \
      -DDEFAULT_CHARSET=utf8 \
      -DDEFAULT_COLLATION=utf8_general_ci \
      -DENABLED_LOCAL_INFILE=1 \
      -DWITH_INNODB_MEMCACHED=ON \
      $BUILD_mysql

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try rm -rf $STAGE_PATH/mysql-test
  try rm -f $STAGE_PATH/LICENCE
  try rm -f $STAGE_PATH/README
  pop_env
}
