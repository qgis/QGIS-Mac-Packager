#!/usr/bin/env bash

# load configuration
if (( $# < 1 )); then
    echo "deps.bash: $0 <path/to>/config/<my>.conf ..."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
shift
source $CONFIG_FILE

echo ""
echo "SYSTEM"
system_profiler SPSoftwareDataType | grep -i "VERSION"

echo ""
echo "DEVELOPER TOOLS"
system_profiler SPDeveloperToolsDataType

echo ""
echo "QGIS-DEPS $QGIS_DEPS_SDK_VERSION"
DEPS=$(grep "VERSION" "${QGIS_DEPS_STAGE_PATH}/qgis-deps.config")
DEPS="${DEPS//export VERSION_/}"
DEPS="${DEPS//export RELEASE_VERSION_/}"
DEPS="${DEPS//export QGIS_DEPS_SDK_VERSION_/}"
DEPS="${DEPS//python_packages_pre_/python: }"
DEPS="${DEPS//python_packages_post_/python: }"
DEPS="${DEPS//python_/python: }"
DEPS="${DEPS//=/ }"
printf "$DEPS"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
echo ""
echo "Updated $TIMESTAMP"