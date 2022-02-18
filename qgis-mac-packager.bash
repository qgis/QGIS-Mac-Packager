#!/bin/bash

set -eo pipefail

PWD=$(pwd)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${DIR}/../scripts/utils.sh"

function usage() {
    echo "usage: ${0} QGIS_VERSION CONFIG_NAME PACKAGE_NAME"
    echo "example: ./${0} nightly 3.18.3 /path/to/qgis_nightly_master_20200717_024956.dmg"
    exit 0
}

####################
# load configuration
if (( $# < 3 )); then
    usge
    exit 1
fi

QGIS_VERSION=${1}
if [[ ${QGIS_VERSION} =~ (\d+){3} ]]; then
  QGIS_MAJOR_VERSION=$(echo ${STR} | cut -d. -f1)
  QGIS_MINOR_VERSION=$(echo ${STR} | cut -d. -f2)
  QGIS_PATCH_VERSION=$(echo ${STR} | cut -d. -f3)
else
  error "QGIS version '${QGIS_VERSION}' is invalid"
fi

QGIS_RELEASE_CONFIG=${2}
if [[ -z "${QGIS_RELEASE_CONFIG}" ]]; then
  usage
  exit 1
fi
CONFIG_FILE="${DIR}/../config/${QGIS_RELEASE_CONFIG}.conf"
if [[ ! -f "${CONFIG_FILE}" ]]; then
  error "config file ${CONFIG_FILE} does not exist"
fi
source ${CONFIG_FILE}



echo "Verifying the QGIS repo is cloned locally in ${QGIS_SOURCE_DIR}"
if [ ! -f "${QGIS_SOURCE_DIR}/INSTALL.md" ]; then
  error "missing ${QGIS_SOURCE_DIR}/INSTALL.md"
fi

echo "Verifying the Qt package installation"
if [ ! -d "${QT_BASE}" ]; then
  error "missing QT in ${QT_BASE}, install version ${VERSION_QT} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
fi

echo "Verifying the qgis-deps package installation"
if [ ! -d "${QGIS_DEPS_STAGE_PATH}" ]; then
  error "missing QGIS-DEPS in ${QGIS_DEPS_STAGE_PATH}, install version ${QGIS_DEPS_SDK_VERSION} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
fi

echo "Building QGIS"
${DIR}/qgis_build/qgis_build.bash "${CONFIG_FILE}" ${QGIS_MAJOR_VERSION} ${QGIS_MINOR_VERSION} ${QGIS_PATCH_VERSION}

echo "Bundle QGIS"
${DIR}/qgis_bundle/qgis_bundle.bash "${CONFIG_FILE}" ${QGIS_MAJOR_VERSION} ${QGIS_MINOR_VERSION} ${QGIS_PATCH_VERSION}

echo "Package QGIS to ${PACKAGE}"
${DIR}/qgis_package/qgis_package.bash "${CONFIG_FILE}" ${QGIS_MAJOR_VERSION} ${QGIS_MINOR_VERSION} ${QGIS_PATCH_VERSION} "${PACKAGE}"

echo "All done (qgis-mac-packager.bash)"
cd "${PWD}"

exit 0