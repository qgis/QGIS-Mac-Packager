#!/usr/bin/env bash

# terminal colors
CRED="\x1b[31;01m"
CBLUE="\x1b[34;01m"
CGRAY="\x1b[30;01m"
CRESET="\x1b[39;49;00m"


function fold_push() {
  echo "::group::${1}"
}
function fold_pop() {
  echo "::endgroup::"
}

SED="/usr/local/bin/gsed -i.orig"

COMPRESS="tar -c -z --exclude=*.pyc -f"
DECOMPRESS="tar -xvzf"

function filesize() {
  du -h ${1} | cut -f 1
}

function mk_sym_link {
  DIR=${1}
  SRC=${2}
  DEST=${3}

  PWD=`pwd`
  cd ${DIR}
  try ln -s ${SRC} ${DEST}
  cd ${PWD}
}

function try() {
    "$@" || exit 1
}

function info() {
  echo -e "${CBLUE}"$@"${CRESET}";
}

function error() {
  MSG="${CRED}"$@"${CRESET}"
  echo -e ${MSG};
  exit 1
}

function debug() {
  echo -e "${CGRAY}"$@"${CRESET}";
}