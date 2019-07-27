#!/bin/bash

set -e

# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# != 6 )); then
    echo "upload_to_qgis2 release_name log dmg deps status_png sha256sum"
    exit 1
fi

RELEASE=$1
LOG=$2
DMG=$3
DEPS=$4
STATUS=$5
MD5SUM=$6

KEY="$DIR/../../ssh/id_rsa"
SERVER="qgis-mac-packager-bot@qgis2.qgis.org"
FOLDER="/var/www/downloads/macos"
ROOT="$FOLDER/$RELEASE"

process_file () {
    LOCAL=$1
    EXTENSION=$2
    FILENAME=$(basename -- "$LOCAL")
    REMOTE=$ROOT/$FILENAME
    LINK=$FOLDER/qgis-macos-$RELEASE.$EXTENSION
    scp -o LogLevel=Error -i $KEY $LOCAL $SERVER:$REMOTE
    ssh -o LogLevel=Error -i $KEY $SERVER "rm -f $LINK"
    ssh -o LogLevel=Error -i $KEY $SERVER "ln -s $REMOTE $LINK"
}

echo "Upload $RELEASE to qgis2.qgis.org"
ssh -o LogLevel=Error -i $KEY $SERVER "mkdir -p $ROOT"

# upload files
if [ -f $DMG ]; then
    # success
    process_file $DMG dmg
    process_file $MD5SUM sha256sum
    process_file $DEPS deps
fi

# success or failure
process_file $LOG latest.log
process_file $STATUS latest.png
