#!/bin/bash

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd $DIR/..

echo "Unit tests"
python3 -m unittest discover tests/ -v

echo "PyCodeStyle"
python3 -m pycodestyle . --max-line-length=120

echo "Usage of print"
PRINT=`grep -rni print\( . --include=*.py --exclude ./qmp/common.py --exclude ./scripts/deps.py`
echo $PRINT
if [ -n "$PRINT" ]; then
    exit 1
fi

cd $PWD
exit 0
