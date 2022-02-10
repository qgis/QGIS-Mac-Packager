#!/bin/bash

set -e

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

####################
# load configuration
if (( $# < 1 )); then
    echo "upload_to_qgis2: $0 <path/to>/config/<my>.conf ..."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
shift
source $CONFIG_FILE

QT_PACKAGE=$ROOT_OUT_PATH/qt-${VERSION_QT}.tar.gz
QGIS_DEPS_PACKAGE=$ROOT_OUT_PATH/qgis-deps-${QGIS_DEPS_SDK_VERSION}.tar.gz
INSTALL_SCRIPT=$ROOT_OUT_PATH/install_qgis_deps-${QGIS_DEPS_SDK_VERSION}.bash

if [ ! -f $QT_PACKAGE ] || [ ! -f $QGIS_DEPS_PACKAGE ] || [ ! -f $INSTALL_SCRIPT ] ; then
  echo "Missing archives to upload, maybe you forgot to run ./create_package.bash?"
  echo "QT archive $QT_PACKAGE"
  echo "QGIS deps archive $QGIS_DEPS_PACKAGE"
  echo "Install script $INSTALL_SCRIPT"
  exit 1
fi

KEY="$DIR/../../ssh/id_rsa"
SERVER="qgis-mac-packager-bot@qgis2.qgis.org"
FOLDER="/var/www/downloads/macos"
ROOT="$FOLDER/deps"

process_file () {
    LOCAL=$1
    FILENAME=$(basename -- "$LOCAL")
    REMOTE=$ROOT/$FILENAME
    # scp -o LogLevel=Error -i $KEY $LOCAL $SERVER:$REMOTE
    rsync -v -e "ssh -i $KEY" $LOCAL $SERVER:$REMOTE --progress
}

echo "Upload QGIS DEPS to qgis2.qgis.org"
ssh -o LogLevel=Error -i $KEY $SERVER "mkdir -p $ROOT"

# upload files
process_file $QT_PACKAGE
process_file $QGIS_DEPS_PACKAGE
process_file $INSTALL_SCRIPT
