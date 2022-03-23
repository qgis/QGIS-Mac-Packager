#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${DIR}/../scripts/utils.sh"

function usage() {
    echo "usage: ${0} CONFIG_NAME QGIS_VERSION PACKAGE"
    echo "example: ./${0} nightly 3.18.3 PACKAGE"
    exit 0
}

####################
# load configuration
if (( $# < 2 )); then
    usge
    exit 1
fi

QGIS_RELEASE_CONFIG=${1}
if [[ -z "${QGIS_RELEASE_CONFIG}" ]]; then
  usage
  exit 1
fi
CONFIG_FILE="${DIR}/../config/${QGIS_RELEASE_CONFIG}.conf"
if [[ ! -f "${CONFIG_FILE}" ]]; then
  error "config file ${CONFIG_FILE} does not exist"
fi

QGIS_VERSION_COMPLETE=${2}
if [[ ${QGIS_VERSION_COMPLETE} =~ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
  export QGIS_MAJOR_VERSION=$(echo ${QGIS_VERSION_COMPLETE} | cut -d. -f1)
  export QGIS_MINOR_VERSION=$(echo ${QGIS_VERSION_COMPLETE} | cut -d. -f2)
  export QGIS_PATCH_VERSION=$(echo ${QGIS_VERSION_COMPLETE} | cut -d. -f3)
else
  error "QGIS version '${QGIS_VERSION_COMPLETE}' is invalid"
fi
QGIS_VERSION="${QGIS_MAJOR_VERSION}.${QGIS_MINOR_VERSION}"

source ${CONFIG_FILE}

PACKAGE=$3

QGIS_APP="$BUNDLE_DIR/$QGIS_APP_NAME"
if [ ! -d "$QGIS_APP" ]; then
  error "missing bundled app $QGIS_APP"
fi

if [ -f "$PACKAGE" ]; then
  info "$PACKAGE exists, removing"
  rm -f "$PACKAGE"
fi

APPLE_CODE_SIGN_IDENTITY={APPLE_CODE_SIGN_IDENTITY:-"Developer ID Application: Open Source Geospatial Foundation"}
#IDENTITY=$(cat "$SIGN_FILE")
#if [ ${#IDENTITY} -ne 40 ]; then
#  error "SIGN FILE $SIGN_FILE invalid. key must have 40 chars" ;
#fi
#
#if [ ! -f "$KEYCHAIN_FILE" ]; then
#  error "keychain file $KEYCHAIN_FILE missing"
#fi

info "Print identities"
security find-identity -v -p codesigning

info "Signing the $QGIS_APP_NAME"
codesign -s "${APPLE_CODE_SIGN_IDENTITY}" -i "org.qgis.qgis" -v --force --timestamp=none "$QGIS_APP" --deep
codesign --deep-verify --verbose "$QGIS_APP"

info "Create dmg image"
dmgbuild \
  -Dapp="$QGIS_APP" \
  -s ${DIR}/resources/dmgsettings.py \
  "$QGIS_APP_NAME" \
  "$PACKAGE"

info "Add license to dmg"
${DIR}/add_license_to_dmg.bash "$PACKAGE"

info "Signing the dmg"
codesign -s "${APPLE_CODE_SIGN_IDENTITY}" -i "org.qgis.qgis" -v --force --timestamp=none "$PACKAGE"
codesign --deep-verify --verbose "$PACKAGE"

info "Create checksum"
sha256sum "$PACKAGE" > "$PACKAGE.sha256sum"

F_SIZE=$(du -h "$PACKAGE")
info "Dmg created with size $F_SIZE"
