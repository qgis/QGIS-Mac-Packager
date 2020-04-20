#!/usr/bin/env bash

# Script to list all rpaths in all binaries

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/config.conf

run() {
  RPATH_DIR_FILENAME=$(basename -- "$RPATH_DIR")
  RESULT_BIN=
  COMMANDS_BIN=

  cd $FOLDER
  LIBS1=`find . -type f -name "*.so"`
  LIBS2=`find . -type f -name "*.dylib"`
  BINS=`find . -type f ! -name "*.*"`
  LIBS="$BINS $LIBS1 $LIBS2"
  for lib in $LIBS; do
      RP=$(otool -l $FOLDER/$lib | grep RPATH -A2)
      LIB="\$BUNDLE_CONTENTS_DIR/${lib:2:${#lib}}"

      if [ "X$RPATH_DIR" == "X" ]; then
        RP=$(otool -l $FOLDER/$lib | grep RPATH -A2)
        if [ ! "X$RP" == "X" ]; then
          echo $FOLDER/$lib
          echo $RP
        fi
      else
        if echo ${RP} | grep -q $RPATH_DIR
        then
            RESULT_BIN="$RESULT_BIN\n$LIB"
            COMMANDS_BIN="$COMMANDS_BIN\n install_name_delete_rpath $RPATH_DIR $LIB"
        fi
      fi
  done

  printf "$RESULT_BIN\n"
  echo "-----------"
  printf "$COMMANDS_BIN\n"
}

if (( $# < 1 )); then
    echo "listing all RPATHs"
fi

FOLDER=$BUNDLE_CONTENTS_DIR
RPATH_DIR=$1
echo "Checking which binaries in $FOLDER have rpath $RPATH_DIR"
run