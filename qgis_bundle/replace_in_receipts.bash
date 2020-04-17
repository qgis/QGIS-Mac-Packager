#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/qgis_bundle.bash
SED="sed -i.orig"

function replace_in_place() {
  FILE=$1
  SRC=$2
  DST=$3
  $SED 's;$SRC;$DEST;g' $FILE
}


function run() {
  RECIPES=`find . -type f ! -name "recipe.*"`
  for recipe in $RECIPES; do
    echo "Patching $recipe"



  done
}

run