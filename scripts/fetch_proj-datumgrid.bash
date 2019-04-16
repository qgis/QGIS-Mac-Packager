#!/usr/bin/env bash

set -e

# 2019 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

WORLD_VER="world-1.0"
EUROPE_VER="europe-1.2"
OCEANIA_VER="oceania-1.0"
NORTH_AMERICA_VER="north-america-1.2"
MAIN_VER="1.8"

WORLD="https://github.com/OSGeo/proj-datumgrid/releases/download/$WORLD_VER/proj-datumgrid-$WORLD_VER.tar.gz"
EUROPE="https://github.com/OSGeo/proj-datumgrid/releases/download/$EUROPE_VER/proj-datumgrid-$EUROPE_VER.tar.gz"
OCEANIA="https://github.com/OSGeo/proj-datumgrid/releases/download/$OCEANIA_VER/proj-datumgrid-$OCEANIA_VER.tar.gz"
NORTH_AMERICA="https://github.com/OSGeo/proj-datumgrid/releases/download/$NORTH_AMERICA_VER/proj-datumgrid-$NORTH_AMERICA_VER.tar.gz"
MAIN="https://github.com/OSGeo/proj-datumgrid/releases/download/$MAIN_VER/proj-datumgrid-$MAIN_VER.tar.gz"

if (( $# == 1 )); then
    echo "- proj-datumgrid-$WORLD_VER"
    echo "- proj-datumgrid-$EUROPE_VER"
    echo "- proj-datumgrid-$OCEANIA_VER"
    echo "- proj-datumgrid-$NORTH_AMERICA_VER"
    echo "- proj-datumgrid-$MAIN_VER"
    exit 0
fi

BUILD_DIR=$DIR/../../proj-datumgrid

rm -rf $BUILD_DIR

echo "Fetching Proj-datumgrid packages to $BUILD_DIR"
mkdir -p $BUILD_DIR
mkdir -p $BUILD_DIR/downloads
cd $BUILD_DIR/downloads
wget -O world.tar.gz $WORLD
wget -O europe.tar.gz $EUROPE
wget -O oceania.tar.gz $OCEANIA
wget -O north_america.tar.gz $NORTH_AMERICA
wget -O main.tar.gz $MAIN

echo "Extracting"
tar -xvzf world.tar.gz
tar -xvzf europe.tar.gz
tar -xvzf oceania.tar.gz
tar -xvzf north_america.tar.gz
tar -xvzf main.tar.gz

echo "Creating proj share folder"
mkdir -p $BUILD_DIR/grids
rsync -av --exclude='*.tar.gz' --exclude='README*' $BUILD_DIR/downloads/ $BUILD_DIR/grids/
