#!/usr/bin/env bash

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Packaging QGIS for MacOS platform"
else
  echo "Unable to package QGIS on $OSTYPE"
  exit 1;
fi

# load configuration
if (( $# < 2 )); then
    echo "qgis_package: $0 <path/to>/config/<my>.conf package_file ..."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
source $CONFIG_FILE

PACKAGE=$2

QGIS_APP=$BUNDLE_DIR/QGIS.app
if [ ! -d "$QGIS_APP" ]; then
  echo "missing bundled app $QGIS_APP"
  exit 1
fi

if [ -f "$PACKAGE" ]; then
  echo "$PACKAGE exists, removing"
  rm -f $PACKAGE
fi

IDENTITY=`cat $SIGN_FILE`
if [ ${#IDENTITY} -ne 40 ]; then
  echo "SIGN FILE $SIGN_FILE invalid. key must have 40 chars" ;
  exit 1
fi

if [ ! -f "$KEYCHAIN_FILE" ]; then
  echo "keychain file $KEYCHAIN_FILE missing"
  exit 1
fi

echo "Print identities"
security find-identity -v -p codesigning

echo "Signing the QGIS.app"
codesign -s $IDENTITY -v --force --keychain $KEYCHAIN_FILE $QGIS_APP
codesign --deep-verify --verbose

echo "Create dmg image"
/usr/local/bin/dmgbuild \
  -Dapp=$QGIS_APP \
  -s `dirname $0`/../resources/dmgsettings.py \
  "QGIS.app" \
  $PACKAGE

echo "Signing the dmg"
codesign -s $IDENTITY -v --force --keychain $KEYCHAIN_FILE $PACKAGE
codesign --deep-verify --verbose

echo "All done (qgis_package)"

echo "Create checksum"

FSIZE=`du -h $PACKAGE`
echo "Dmg created with size $FSIZE"