#!/bin/bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ALGNAME=$1
shift;

# This runs from Contents/MacOS/bin directory
export PROJ_LIB=$THISDIR/../../Resources/proj
export GDAL_DRIVER_PATH=$THISDIR/../lib/gdalplugins
export GDAL_DATA=$THISDIR/../../Resources/gdal

"$THISDIR/_$ALGNAME" "$@"
