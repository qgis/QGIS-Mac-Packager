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

if [ ! -f "$SIGN_FILE" ]; then
  error "identity file $SIGN_FILE missing"
fi

IDENTITY=$(cat $SIGN_FILE)

if [ ${#IDENTITY} -ne 40 ]; then
  error "SIGN FILE $SIGN_FILE invalid. key must have 40 chars" ;
fi

if [ ! -f "$KEYCHAIN_FILE" ]; then
  error "keychain file $KEYCHAIN_FILE missing"
fi

echo "Signing binaries in $PATH_TO_SIGN"
LIBS=$(find "$PATH_TO_SIGN" -type f)

echo "This make take few minutes..."
for LIB in $LIBS; do
  sem -j+0 "codesign --force -s $IDENTITY --keychain $KEYCHAIN_FILE $LIB"
done
sem --wait

echo "Signing done"