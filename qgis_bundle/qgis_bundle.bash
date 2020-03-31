#!/usr/bin/env bash

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building QGIS dependencies for MacOS platform"
else
  echo "Unable to build MacOS binaries on $OSTYPE"
  exit 1;
fi

# Internals
CRED="\x1b[31;01m"
CBLUE="\x1b[34;01m"
CGRAY="\x1b[30;01m"
CRESET="\x1b[39;49;00m"

function try () {
    "$@" || exit -1
}

function info() {
  echo -e "$CBLUE"$@"$CRESET";
}

function error() {
  MSG="$CRED"$@"$CRESET"
  echo -e $MSG;
  exit -1
}

function debug() {
  echo -e "$CGRAY"$@"$CRESET";
}

source `dirname $0`/../qgis_deps/config.conf
if [ -d $ROOT_OUT_PATH/stage ]; then
       info "Using qgis_deps: $ROOT_OUT_PATH/stage"
else
       error "Missing qgis_deps directory '$ROOT_OUT_PATH/stage' not found."
fi

source $ROOT_OUT_PATH/stage/qgis-deps.config
