#!/usr/bin/env bash

set -euo pipefail

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
  error "missing bundled app $QGIS_APP"
fi

if [ -f "$PACKAGE" ]; then
  info "$PACKAGE exists, removing"
  rm -f $PACKAGE
fi

IDENTITY=`cat $SIGN_FILE`
if [ ${#IDENTITY} -ne 40 ]; then
  error "SIGN FILE $SIGN_FILE invalid. key must have 40 chars" ;
fi

if [ ! -f "$KEYCHAIN_FILE" ]; then
  error "keychain file $KEYCHAIN_FILE missing"
fi

info "Print identities"
security find-identity -v -p codesigning

info "Signing the QGIS.app"
codesign -s $IDENTITY -v --force --keychain $KEYCHAIN_FILE $QGIS_APP --deep
codesign --deep-verify --verbose $QGIS_APP

info "Create dmg image"
dmgbuild \
  -Dapp=$QGIS_APP \
  -s `dirname $0`/../resources/dmgsettings.py \
  "QGIS.app" \
  $PACKAGE

info "Signing the dmg"
codesign -s $IDENTITY -v --force --keychain $KEYCHAIN_FILE $PACKAGE
codesign --deep-verify --verbose

info "Create checksum"
sha256sum $PACKAGE > $PACKAGE.sha256sum

FSIZE=`du -h $PACKAGE`
info "Dmg created with size $FSIZE"