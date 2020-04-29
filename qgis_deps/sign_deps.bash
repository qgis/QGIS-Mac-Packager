#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PATH_TO_SIGN=$1
IDENTITY_FILE=$DIR/../../sign_identity.txt
KEYCHAIN_FILE=$DIR/../../qgis.keychain-db

if [ ! -f "$IDENTITY_FILE" ]; then
   echo "Missing IDENTITY_FILE $IDENTITY_FILE"
   exit 1
fi

if [ ! -f "$KEYCHAIN_FILE" ]; then
   echo "Missing KEYCHAIN_FILE $KEYCHAIN_FILE"
   exit 1
fi

if [ "X$PATH_TO_SIGN" == "X" ]; then
   echo "you need to specify PATH_TO_SIGN"
   exit 1
fi

IDENTITY="$(cat $IDENTITY_FILE)"

echo "Signing binaries in $PATH_TO_SIGN"
LIBS1=`find $PATH_TO_SIGN -type f -name "*.so"`
LIBS2=`find $PATH_TO_SIGN -type f -name "*.dylib"`
BINS=`find $PATH_TO_SIGN -type f ! -name "*.*"`
LIBS="$BINS $LIBS1 $LIBS2"
for LIB in $LIBS; do
    if file $LIB | grep -q Mach-O
    then
      codesign -s $IDENTITY -v --deep --keychain $KEYCHAIN_FILE $LIB
    fi
done

echo "Signing done"