#!/bin/bash

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd $DIR/..

echo "Unit tests"
python3 -m unittest discover tests/ -v

echo "PyCodeStyle"
python3 -m pycodestyle . --max-line-length=120

echo "Usage of print"
PRINT=`find . -name "*.py" ! -path ./scripts/deps.py ! -path ./qgis_deps/tools/depsort.py | xargs grep -ni print\(`
echo $PRINT
if [ -n "$PRINT" ]; then
    exit 1
fi

cd $PWD
exit 0
