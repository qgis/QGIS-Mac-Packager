#!/bin/bash
BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
GRASSDIR=$BINDIR/../../Resources/grassREPLACEVERSION
PROJDIR=$BINDIR/../../Resources/proj

export PATH=$BINDIR:$GRASSDIR:$PATH
export GISBASE=$GRASSDIR
export GRASS_PROJSHARE=$PROJDIR

$BINDIR/_grassREPLACEVERSION "$@"
