#!/usr/bin/env bash

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building QGIS dependencies for MacOS platform"
else
  echo "Unable to build MacOS binaries on $OSTYPE"
  exit 1;
fi