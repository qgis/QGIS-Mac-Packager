#!/bin/bash

set -e
echo "Unit tests"
python3 -m unittest discover tests/ -v

echo "PyCodeStyle"
python3 -m pycodestyle . --max-line-length=120

echo "Usage of print"

PRINT="grep -rni print\( . --include=*.py --exclude ./qmp/common.py --exclude ./qmp/bundler/deps.py"
eval $PRINT
NLINES=`eval $PRINT | wc -l`
if [ $NLINES -gt 0 ]; then
    exit 1
fi
