#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

####################
# load configuration
if (( $# < 1 )); then
    echo "sign_deps: $0 <path/to>/config/<my>.conf ..."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
shift
source $CONFIG_FILE

PATH_TO_SIGN=$ROOT_OUT_PATH/stage/

IDENTITY=`cat $SIGN_FILE`
if [ ${#IDENTITY} -ne 40 ]; then
  error "SIGN FILE $SIGN_FILE invalid. key must have 40 chars" ;
fi

if [ ! -f "$KEYCHAIN_FILE" ]; then
  error "keychain file $KEYCHAIN_FILE missing"
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