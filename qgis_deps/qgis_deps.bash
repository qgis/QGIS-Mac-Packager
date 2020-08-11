#!/usr/bin/env bash

set -eu

if (( $# < 1 )); then
    echo "qgis_deps: $0 <path/to>/config/<my>.conf"
    exit 1
fi

CONFIG_FILE=$1

time `dirname $0`/distribute.sh $CONFIG_FILE -mqgis_deps