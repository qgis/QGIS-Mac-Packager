#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/config.conf

function check_binary_linker_links() {
  OTOOL_L=$(otool -L ${BUNDLE_DIR}/$1)
  OTOOL_RPATH=$(otool -l ${BUNDLE_DIR}/$1)

  if echo "${OTOOL_L}" | grep -q /usr/local/
  then
    echo "${OTOOL_L}"
    error "$1 contains /usr/local/ string <-- Picked some homebrew libraries!"
  fi

  if echo "${OTOOL_L}"  | grep -q $QGIS_INSTALL_DIR
  then
    echo "${OTOOL_L}"
    error "$1 contains $QGIS_INSTALL_DIR string <-- forgot to change install_name for the linked library?"
  fi

  if echo "${OTOOL_L}"  | grep -q $STAGE_PATH
  then
    echo "${OTOOL_L}"
    error "$1 contains $STAGE_PATH string <-- forgot to change install_name for the linked library?"
  fi

  if echo ${OTOOL_L} | grep -q $BUNDLE_DIR
  then
    echo "${OTOOL_L}"
    error "$1 contains $BUNDLE_DIR string <-- forgot to change install_name for the linked library?"
  fi

  targets=(
    libz
    libssl
    libcrypto
    libpq
    lib
    libxml2
    libsqlite3
  )

  for i in ${targets[*]}
  do
      if echo "${OTOOL_L}" | grep -q /usr/lib/$i.dylib
      then
        echo "${OTOOL_L}"
        info "$1 contains /usr/lib/$i.dylib string -- we should be using our $i, not system!"
      fi
  done
}

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
    echo "usage: $0 bundle_contents_folder binary"
    exit 1
fi

FOLDER=$BUNDLE_CONTENTS_DIR
BINARY=$1
echo "Checking which binaries in $FOLDER link $BINARY"
run