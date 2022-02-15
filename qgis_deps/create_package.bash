#!/usr/bin/env bash

set -e

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${CUR_DIR}/../scripts/utils.sh

CURRENT_PWD=$(pwd)


####################
# load configuration
QGIS_DEPS_RELEASE_VERSION=$1
if [ -z ${QGIS_DEPS_RELEASE_VERSION} ]; then
  error "first argument should be the version of the deps (use ./create_package.bash 0.x)"
  exit 1
fi
CONFIG_FILE="config/deps-${QGIS_DEPS_RELEASE_VERSION}.conf"
if [[ ! -f "${CONFIG_FILE}" ]]; then
  error "invalid config file ${CONFIG_FILE}"
fi
shift
source ${CONFIG_FILE}

if [ ! -d ${ROOT_OUT_PATH} ]; then
  error "The root output directory '${ROOT_OUT_PATH}' not found."
fi

echo "Create packages for qgis-deps-${QGIS_DEPS_SDK_VERSION}"



##############################################
# Create QT package
QT_INSTALL_DIR=${QGIS_DEPS_PREFIX}${QT_BASE}/clang_64
if [ -f ${QT_PACKAGE_PATH} ]; then
  echo "Archive ${QT_PACKAGE_PATH} exists, skipping"
else
  cd ${QT_BASE}/clang_64
  ${COMPRESS} ${QT_PACKAGE_PATH} ./
  cd ${CURRENT_PWD}
fi

##############################################
# Create Deps package
QGIS_INSTALL_DIR=${QGIS_DEPS_PREFIX}${ROOT_OUT_PATH}/stage/

if [ -f ${QGIS_DEPS_PACKAGE_PATH} ]; then
  echo "Archive ${QGIS_DEPS_PACKAGE_PATH} exists, removing"
  rm -rf ${QGIS_DEPS_PACKAGE_PATH}
fi

cd ${ROOT_OUT_PATH}/stage/
${COMPRESS} ${QGIS_DEPS_PACKAGE_PATH} ./
cd ${CURRENT_PWD}


##############################################
# Create install script
INSTALL_SCRIPT=${ROOT_OUT_PATH}/install_qgis_deps-${QGIS_DEPS_SDK_VERSION}.bash
if [ -f ${INSTALL_SCRIPT} ]; then
  rm -rf ${INSTALL_SCRIPT}
fi
cp install_qgis_deps.bash.template ${INSTALL_SCRIPT}
chmod +x ${INSTALL_SCRIPT}
gsed -i "s|__VERSION_QT__|${VERSION_QT}|g" ${INSTALL_SCRIPT}
gsed -i "s|__QT_PACKAGE_PATH__|${QT_PACKAGE_PATH}|g" ${INSTALL_SCRIPT}
gsed -i "s|__QT_INSTALL_DIR__|${QT_INSTALL_DIR}|g" ${INSTALL_SCRIPT}
gsed -i "s|__QGIS_DEPS_SDK_VERSION__|${QGIS_DEPS_SDK_VERSION}|g" ${INSTALL_SCRIPT}
gsed -i "s|__QGIS_INSTALL_DIR__|${QGIS_INSTALL_DIR}|g" ${INSTALL_SCRIPT}

##############################################


echo "QT archive ${QT_PACKAGE_PATH} (`filesize ${QT_PACKAGE_PATH}`)"
echo "QGIS deps archive ${QGIS_DEPS_PACKAGE_PATH} (`filesize ${QGIS_DEPS_PACKAGE_PATH}`)"
echo "Install script ${INSTALL_SCRIPT} (`filesize ${INSTALL_SCRIPT}`)"
