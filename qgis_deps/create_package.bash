#!/usr/bin/env bash

set -e

function error() {
  echo -e $1;
  exit -1
}

PWD=`pwd`
COMPRESS="tar -c -z --exclude=*.pyc -f"
DECOMPRESS="tar -xvzf"
function filesize() {
  du -h $1 | cut -f 1
}

####################
# load configuration
if (( $# < 1 )); then
    echo "create_package: $0 <path/to>/config/<my>.conf ..."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
shift
source $CONFIG_FILE

if [ ! -d $ROOT_OUT_PATH ]; then
  error "The root output directory '$ROOT_OUT_PATH' not found."
fi

echo "Create packages for qgis-deps-${RELEASE_VERSION}"

##############################################
# Create install script
INSTALL_SCRIPT=$ROOT_OUT_PATH/install_qgis_deps-${RELEASE_VERSION}.bash
if [ -f $INSTALL_SCRIPT ]; then
  rm -rf $INSTALL_SCRIPT
  touch $INSTALL_SCRIPT
  chmod +x $INSTALL_SCRIPT
  echo "#!/usr/bin/env bash" >> $INSTALL_SCRIPT
  echo "set -e" >> $INSTALL_SCRIPT
  echo "ROOT_PATH=\"\$( cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" && pwd )\"" >> $INSTALL_SCRIPT
  echo "echo \"Running qgis-deps installer\"" >> $INSTALL_SCRIPT
fi

##############################################
# Create QT package
QT_PACKAGE_FILE=qt-${VERSION_qt}.tar.gz
QT_PACKAGE=$ROOT_OUT_PATH/${QT_PACKAGE_FILE}
QT_INSTALL_DIR=\$\{QGIS_DEPS_PREFIX\}$QT_BASE/clang_64
if [ -f $QT_PACKAGE ]; then
  echo "Archive $QT_PACKAGE exists, skipping"
else
  cd $QT_BASE/clang_64
  $COMPRESS ${QT_PACKAGE} ./
  cd $PWD
fi

echo "echo \"----------------------\"" >> $INSTALL_SCRIPT
echo "if [ -f \$ROOT_PATH/$QT_PACKAGE_FILE ] && [ ! -d $QT_INSTALL_DIR ]; then" >> $INSTALL_SCRIPT
echo "  echo \"Installing QT ${VERSION_qt} to $QT_INSTALL_DIR\"" >> $INSTALL_SCRIPT
echo "  mkdir -p $QT_INSTALL_DIR" >> $INSTALL_SCRIPT
echo "  cd $QT_INSTALL_DIR" >> $INSTALL_SCRIPT
echo "  $DECOMPRESS \$ROOT_PATH/$QT_PACKAGE_FILE" >> $INSTALL_SCRIPT
echo "else " >> $INSTALL_SCRIPT
echo "  echo \"Skipped installation of QT ${VERSION_qt} to $QT_INSTALL_DIR\"" >> $INSTALL_SCRIPT
echo "fi" >> $INSTALL_SCRIPT

##############################################
# Create Deps package
QGIS_DEPS_PACKAGE_FILE=qgis-deps-${RELEASE_VERSION}.tar.gz
QGIS_DEPS_PACKAGE=$ROOT_OUT_PATH/${QGIS_DEPS_PACKAGE_FILE}
QGIS_INSTALL_DIR=\$\{QGIS_DEPS_PREFIX\}$ROOT_OUT_PATH/stage/
if [ -f $QGIS_DEPS_PACKAGE ]; then
  echo "Archive $QGIS_DEPS_PACKAGE exists, removing"
  rm -rf $QGIS_DEPS_PACKAGE
fi

cd $ROOT_OUT_PATH/stage/
$COMPRESS ${QGIS_DEPS_PACKAGE} ./
cd $PWD
echo "echo \"----------------------\"" >> $INSTALL_SCRIPT
echo "if [ -f \$ROOT_PATH/$QGIS_DEPS_PACKAGE_FILE ] && [ ! -d $QGIS_INSTALL_DIR ]; then" >> $INSTALL_SCRIPT
echo "  echo \"Installing QGIS_deps ${RELEASE_VERSION} to $QGIS_INSTALL_DIR\"" >> $INSTALL_SCRIPT
echo "  mkdir -p $QGIS_INSTALL_DIR" >> $INSTALL_SCRIPT
echo "  cd $QGIS_INSTALL_DIR" >> $INSTALL_SCRIPT
echo "  $DECOMPRESS \$ROOT_PATH/$QGIS_DEPS_PACKAGE_FILE" >> $INSTALL_SCRIPT
echo "else " >> $INSTALL_SCRIPT
echo "  echo \"Skipped installation of QGIS_deps ${RELEASE_VERSION} to $QGIS_INSTALL_DIR\"" >> $INSTALL_SCRIPT
echo "fi" >> $INSTALL_SCRIPT

##############################################
# finalize create_package script
echo "echo \"----------------------\"" >> $INSTALL_SCRIPT
echo "echo \"QT installed $QT_INSTALL_DIR\"" >> $INSTALL_SCRIPT
echo "echo \"QGIS deps installed $QGIS_INSTALL_DIR\"" >> $INSTALL_SCRIPT

echo ""
echo "QT archive $QT_PACKAGE (`filesize $QT_PACKAGE`)"
echo "QGIS deps archive $QGIS_DEPS_PACKAGE (`filesize $QGIS_DEPS_PACKAGE`)"
echo "Install script $INSTALL_SCRIPT (`filesize $INSTALL_SCRIPT`)"
