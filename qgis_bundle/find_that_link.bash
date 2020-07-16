#!/usr/bin/env bash

# Script to find which libraries link other libraries for bundle recipes

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/config.conf

run() {
  BINARY_FILENAME=$(basename -- "$BINARY")
  RESULT_BIN=
  COMMANDS_BIN=

  cd $FOLDER
  LIBS1=`find . -type f -name "*.so"`
  LIBS2=`find . -type f -name "*.dylib"`
  BINS=`find . -type f ! -name "*.*"`
  LIBS="$BINS $LIBS1 $LIBS2"
  for lib in $LIBS; do
      OTOOL_L=$(otool -L $FOLDER/$lib)
      if echo ${OTOOL_L} | grep -q $BINARY
      then
        RESULT_BIN="$RESULT_BIN\n$lib"
        LIB="\$BUNDLE_CONTENTS_DIR/${lib:2:${#lib}}"
        COMMANDS_BIN="$COMMANDS_BIN\n install_name_change $BINARY @rpath/$BINARY_FILENAME $LIB"
      fi
  done

  printf "$RESULT_BIN\n"
  echo "-----------"
  printf "$COMMANDS_BIN\n"

  RESULT_TEXT=
  COMMANDS_TEXT=
  # all other files
  # if grep -rni $BUNDLE_DIR .
  # then
  #  grep -rni $STAGE_PATH $STAGE_PATH
  #  error "Some scripts reference absolute BUNDLE_DIR dir $BUNDLE_DIR"
  #fi
}

if (( $# < 1 )); then
    echo "usage: $0 binary"
    exit 1
fi

FOLDER=$BUNDLE_CONTENTS_DIR
BINARY=$1
echo "Checking which binaries in $FOLDER link $BINARY"
run