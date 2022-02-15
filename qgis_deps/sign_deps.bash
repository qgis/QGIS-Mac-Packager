#!/usr/bin/env bash

set -e

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/../scripts/utils.sh

# load configuration
QGIS_DEPS_RELEASE_VERSION=${1}
if [ -z ${QGIS_DEPS_RELEASE_VERSION} ]; then
  error "first argument should be the version of the deps (use ./sign_deps.bash 0.x)"
  exit 1
fi
CONFIG_FILE="config/deps-${QGIS_DEPS_RELEASE_VERSION}.conf"
if [[ ! -f "${CONFIG_FILE}" ]]; then
  error "invalid config file ${CONFIG_FILE}"
fi
shift
source ${CONFIG_FILE}

PATH_TO_SIGN=${STAGE_PATH}

if [ ${#APPLE_CODE_SIGN_IDENTITY} -ne 40 ]; then
  error "SIGN IDENTITY invalid. key must have 40 chars" ;
fi

echo "Cleaning tmp files"
for i in *.swp *.orig *.pyc
do
  info "Cleaning ${i} files"
  find "${PATH_TO_SIGN}" -type fl -name ${i} -exec rm -f {} +
done
for i in __pycache__
do
  info "Cleaning ${i} dirs"
  find "${PATH_TO_SIGN}" -type dl -name "${i}" -exec rm -rf {} +
done

echo "Signing binaries in ${PATH_TO_SIGN}"
FRAMEWORKS=$(find "${PATH_TO_SIGN}" -type f ! -name "*.*" -path "*framework/*" -not -path "*/Headers/*")
BINS=$(find "${PATH_TO_SIGN}/bin/" -type f ! -name "*.py*")
DYLIBS=$(find "${PATH_TO_SIGN}" -type f -name "*.dylib")
SO=$(find "${PATH_TO_SIGN}" -type f -name "*.so")

TO_SIGN=
total=0
for BINARY in ${FRAMEWORKS} ${BINS} ${DYLIBS} ${SO}; do
  attachmenttype=$(file ${BINARY} | cut -d\  -f2 )
  if [[ ${attachmenttype} = "Mach-O" ]]; then
    TO_SIGN="${TO_SIGN} ${BINARY}"
    ((total=total+1))
  fi
done

echo "This make take few minutes..., signing ${total} binaries"
i=0
for LIB in ${TO_SIGN}; do
  ((i=i+1))
  echo "(${i}/${total}) signing => ${LIB}"
  sem -j+0 "codesign --force -s ${APPLE_CODE_SIGN_IDENTITY} ${LIB}"
done
sem --wait

echo "Signing done"
