#!/bin/bash
GRASSDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
GRASSDIR=$(perl -MCwd -e 'print Cwd::abs_path shift' $GRASSDIR)
BINDIR=$GRASSDIR/../../MacOS/bin
PROJDIR=$GRASSDIR/../proj

export PATH=$GRASSDIR/bin:$BINDIR:$PATH
export GISBASE=$GRASSDIR
export GRASS_PROJSHARE=$PROJDIR

$GRASSDIR/_grass "$@"
