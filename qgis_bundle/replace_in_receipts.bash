#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/config.conf
SED="sed -i.orig"

function replace_in_place() {
  FILE=$1
  SRC=$2
  DEST=$3
  $SED "s;$SRC;$DEST;g" $FILE
  rm $FILE.orig
}


function run() {
  RECIPES=`find $DIR/recipes -type f`
  for recipe in $RECIPES; do
    echo "Patching $recipe"

    replace_in_place $recipe $DEPS_LIB_DIR "\$DEPS_LIB_DIR"
  done
}



run