#!/usr/bin/env bash

set -e

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${CUR_DIR}/../scripts/utils.sh

CURRENT_PWD=$(pwd)


####################
# load configuration
# Load configuration
if [[ -z ${MAC_PACKAGE_CONFIG} ]]; then
  error "MAC_PACKAGE_CONFIG variable should be set"
fi
CONFIG_FILE=../config/${MAC_PACKAGE_CONFIG}.conf
if [ ! -f "${CONFIG_FILE}" ]; then
  error "invalid config file (1st argument) ${CONFIG_FILE}"
fi
source ${CONFIG_FILE}


if [ ! -d ${ROOT_OUT_PATH} ]; then
  error "The root output directory '${ROOT_OUT_PATH}' not found."
fi

echo "Create packages for qgis-deps-${QGIS_DEPS_SDK_VERSION}"



##############################################
# Create QT package
QT_PACKAGE=${ROOT_OUT_PATH}/qt-${VERSION_qt}.tar.gz
QT_INSTALL_DIR=\$\{QGIS_DEPS_PREFIX\}${QT_BASE}/clang_64
if [ -f ${QT_PACKAGE} ]; then
  echo "Archive ${QT_PACKAGE} exists, skipping"
else
  cd ${QT_BASE}/clang_64
  ${COMPRESS} ${QT_PACKAGE} ./
  cd ${CURRENT_PWD}
fi

##############################################
# Create Deps package
QGIS_DEPS_PACKAGE_FILE=qgis-deps-${QGIS_DEPS_SDK_VERSION}.tar.gz
QGIS_DEPS_PACKAGE=${ROOT_OUT_PATH}/qgis-deps-${QGIS_DEPS_SDK_VERSION}.tar.gz
QGIS_INSTALL_DIR=\$\{QGIS_DEPS_PREFIX\}${ROOT_OUT_PATH}/stage/

if [ -f ${QGIS_DEPS_PACKAGE} ]; then
  echo "Archive ${QGIS_DEPS_PACKAGE} exists, removing"
  rm -rf ${QGIS_DEPS_PACKAGE}
fi

cd ${ROOT_OUT_PATH}/stage/
${COMPRESS} ${QGIS_DEPS_PACKAGE} ./
cd ${CURRENT_PWD}


##############################################
# Create install script
INSTALL_SCRIPT=${ROOT_OUT_PATH}/install_qgis_deps-${QGIS_DEPS_SDK_VERSION}.bash
if [ -f ${INSTALL_SCRIPT} ]; then
  rm -rf ${INSTALL_SCRIPT}
  touch ${INSTALL_SCRIPT}
  chmod +x ${INSTALL_SCRIPT}
fi
sed -i "s/__VERSION_QT__/${VERSION_qt}/g" ${INSTALL_SCRIPT}
sed -i "s/__QT_INSTALL_DIR__/${QT_INSTALL_DIR}/g" ${INSTALL_SCRIPT}
sed -i "s/__QGIS_DEPS_SDK_VERSION__/${QGIS_DEPS_SDK_VERSION}/g" ${INSTALL_SCRIPT}
sed -i "s/__QGIS_INSTALL_DIR__/${QGIS_INSTALL_DIR}/g" ${INSTALL_SCRIPT}

##############################################
# finalize create_package script
echo "echo \"----------------------\"" >> ${INSTALL_SCRIPT}
echo "echo \"QT installed ${QT_INSTALL_DIR}\"" >> ${INSTALL_SCRIPT}
echo "echo \"QGIS deps installed ${QGIS_INSTALL_DIR}\"" >> ${INSTALL_SCRIPT}

echo ""
echo "QT archive ${QT_PACKAGE} (`filesize ${QT_PACKAGE}`)"
echo "QGIS deps archive ${QGIS_DEPS_PACKAGE} (`filesize ${QGIS_DEPS_PACKAGE}`)"
echo "Install script ${INSTALL_SCRIPT} (`filesize ${INSTALL_SCRIPT}`)"
