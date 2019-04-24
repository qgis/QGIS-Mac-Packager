#!/bin/bash

set -e

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd $DIR/..

echo "Unit tests"
python3 -m unittest discover tests/ -v

echo "PyCodeStyle"
python3 -m pycodestyle . --max-line-length=120

echo "Usage of print"

PRINT="grep -rni print\( . --include=*.py --exclude ./qmp/common.py --exclude ./scripts/deps.py"
eval $PRINT
NLINES=`eval $PRINT | wc -l`
if [ $NLINES -gt 0 ]; then
    exit 1
fi

cd $PWD
