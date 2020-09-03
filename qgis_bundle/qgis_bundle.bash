#!/usr/bin/env bash

set -o pipefail

QGIS_BUNDLE_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

####################
# load configuration
if (( $# < 1 )); then
    echo "qgis_bundle: $0 <path/to>/config/<my>.conf ..."
    exit 1
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
shift
source $CONFIG_FILE

# source the ENV vars from the qgis_deps
if [ ! -f "$QGIS_DEPS_STAGE_PATH/qgis-deps.config" ]; then
  error "missing $QGIS_DEPS_STAGE_PATH/qgis-deps.config"
fi
source $QGIS_DEPS_STAGE_PATH/qgis-deps.config

export DEPS_PYTHON_PACKAGES_DIR=$STAGE_PATH/lib/python${VERSION_major_python}
export DEPS_GRASS_ROOT_DIR=$DEPS_ROOT_DIR/grass${VERSION_grass_major}${VERSION_grass_minor}
export DEPS_GRASS_LIB_DIR=$DEPS_GRASS_ROOT_DIR/lib

####################

function install_name_add_rpath {
  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_add_rpath)"
  fi
  try install_name_tool -add_rpath $1 $2
}

function install_name_delete_rpath {
  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_delete_rpath)"
  fi
  try install_name_tool -delete_rpath $1 $2
}

function install_name_change {

  if [ ! -f "$3" ]; then
    error "Missing $3 (install_name_change)"
  fi
  try install_name_tool -change $1 $2 $3
}

function install_name_id {

  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_id)"
  fi
  try install_name_tool -id $1 $2
}

function fix_exec_link {
  FROMSTR=$1
  TOSTR=$2
  FILENAME=$3
  # https://stackoverflow.com/a/62268465/2838364
  try ${SED} "s&\#\!$FROMSTR&\#\!/usr/bin/perl -e\$_=\$ARGV\[0\]\;s/\[^\\\/\]+\$/$TOSTR/\;exec(\$_,\@ARGV)&g" "$FILENAME"
  try ${SED} "s;exec $FROMSTR;exec \'\`dirname \$0\`/$TOSTR\';g" "$FILENAME"
}

function clean_path {
  FNAME=$1

  try ${SED} "s;$ROOT_OUT_PATH;/MISSING/DEPS/;g" $FNAME
  try ${SED} "s;/opt/;/MISSING/OPT/;g" $FNAME
  try ${SED} "s;/usr/local/;/MISSING/LOCAL/;g" $FNAME
}

function clean_binary {
  try python3 $QGIS_BUNDLE_SCRIPT_DIR/replace_string_in_file.py \
    --file $1 \
    --install_path $QGIS_INSTALL_DIR \
    --bundle_path $BUNDLE_DIR \
    --stage_path $ROOT_OUT_PATH
}

#################################
# FIND all modules - the order does not matter here
MODULES=
for dir in `dirname $0`/recipes/*/
do
    dir=${dir%*/}
    MODULES="$MODULES ${dir##*/}"
done

# COMMANDS
RSYNCDIR="rsync -r"
CP=cp

function env_var_exists() {
  VAR=$1
  VAL=$(eval echo \$$VAR)
  echo "$VAR: $VAL"
  if [ "X$VAL" == "X" ]; then
     error "Missing config variable $VAR ... forgot to run full qgis_deps script?"
  fi
}

function run_prepare_bundle_dir() {
  rm -rf $BUNDLE_DIR
  mkdir -p $BUNDLE_DIR
  mkdir -p $BUNDLE_CONTENTS_DIR
  mkdir -p $BUNDLE_FRAMEWORKS_DIR
  mkdir -p $BUNDLE_RESOURCES_DIR
  mkdir -p $BUNDLE_MACOS_DIR
  mkdir -p $BUNDLE_BIN_DIR
  mkdir -p $BUNDLE_PLUGINS_DIR
  mkdir -p $BUNDLE_LIB_DIR
}

function run_check() {
  for module in ${MODULES[*]}; do
    fn=$(echo check_$module)
    debug "Call $fn"
    $fn
  done
}

function run_bundle() {
  for module in ${MODULES[*]}; do
    fn=$(echo bundle_$module)
    debug "Call $fn"
    $fn
  done
}

function run_postbundle() {
  for module in ${MODULES[*]}; do
    fn1=$(echo fix_binaries_$module)
    debug "Call $fn1"
    $fn1

    fn2=$(echo fix_binaries_${module}_check)
    debug "Call $fn2"
    $fn2

    fn3=$(echo fix_paths_$module)
    debug "Call $fn3"
    $fn3

    fn4=$(echo fix_paths_${module}_check)
    debug "Call $fn4"
    $fn4
  done
}

function run_source_modules() {
  for module in ${MODULES[*]}; do
    source $RECIPES_PATH/$module/recipe.sh
  done
}

function check_binary_linker_links() {
  cd ${BUNDLE_DIR}
  OTOOL_L=$(otool -L $1)

  ok="true"

  #### LINKED LIBS
  if [ -z "$OTOOL_L" ]; then
    echo "No LINKS in $1"
  else
    if echo "${OTOOL_L}" | grep -q /usr/local/
    then
      echo "$1 contains /usr/local/ string <-- Picked some homebrew libraries!"
      ok="false"
    fi

    if echo "${OTOOL_L}"  | grep -q $QGIS_INSTALL_DIR
    then
      echo "$1 contains $QGIS_INSTALL_DIR string <-- forgot to change install_name for the linked library?"
      ok="false"
    fi

    if echo "${OTOOL_L}"  | grep -q $QGIS_BUILD_DIR
    then
      echo "$1 contains $QGIS_BUILD_DIR string <-- forgot to change install_name for the linked library?"
      ok="false"
    fi

    if echo "${OTOOL_L}"  | grep -q $STAGE_PATH
    then
      echo "$1 contains $STAGE_PATH string <-- forgot to change install_name for the linked library?"
      ok="false"
    fi

    if echo "${OTOOL_L}"  | grep -q $QT_BASE
    then
      echo "$1 contains $QT_BASE string <-- forgot to change install_name for the linked library?"
      ok="false"
    fi

    if echo ${OTOOL_L} | grep -q $BUNDLE_DIR
    then
      echo "$1 contains $BUNDLE_DIR string <-- forgot to change install_name for the linked library?"
      ok="false"
    fi

    targets=(
      libz
      libssl
      libcrypto
      libpq
      libexpat
      libiconv
      libxml2
      libsqlite3
    )

    for i in ${targets[*]}
    do
        if echo "${OTOOL_L}" | grep -q "/usr/lib/$i*.dylib"
        then
          echo "$1 contains /usr/lib/$i.dylib string -- we should be using our $i, not system!"
          ok="false"
        fi
    done
  fi

  ######## RPATH
  OTOOL_RPATH=$(otool -l $1 | grep RPATH -A2)
  if [ ! -z "$OTOOL_RPATH" ]; then
    if echo "${OTOOL_RPATH}" | grep -q /usr/local/
    then
      echo "$1 RPATH contains /usr/local/ string <-- forgot to delete/modify RPATH?"
      ok="false"
    fi

    if echo "${OTOOL_RPATH}"  | grep -q $QGIS_INSTALL_DIR
    then
      echo "$1 RPATH contains $QGIS_INSTALL_DIR string <-- forgot to delete/modify RPATH?"
      ok="false"
    fi

    if echo "${OTOOL_RPATH}"  | grep -q $ROOT_OUT_PATH
    then
      echo "$1 RPATH contains $ROOT_OUT_PATH string <-- forgot to delete/modify RPATH?"
      ok="false"
    fi

    if echo ${OTOOL_RPATH} | grep -q $BUNDLE_DIR
    then
      echo "$1 RPATH contains $BUNDLE_DIR string <-- forgot to delete/modify RPATH?"
      ok="false"
    fi
  fi

  if [[ "$ok" == "false" ]]; then
      echo "${OTOOL_L}"
      echo "${OTOOL_RPATH}"
      error "error encountered by checking $1"
  fi
}

function check_file_path() {
  ok="true"
  if grep -rni /usr/local/ $1
  then
    grep -rni /usr/local/ $1
    echo "$1 reference absolute /usr/local/ dir"
    ok="false"
  fi
  if grep -rni $QGIS_INSTALL_DIR $1
  then
    grep -rni $QGIS_INSTALL_DIR $1
    echo "$1 reference absolute $QGIS_INSTALL_DIR dir"
    ok="false"
  fi
  if grep -rni $ROOT_OUT_PATH $1
  then
    grep -rni $ROOT_OUT_PATH $1
    echo "$1 reference absolute $ROOT_OUT_PATH dir"
    ok="false"
  fi
  if grep -rni $BUNDLE_DIR $1
  then
    grep -rni $BUNDLE_DIR $1
    echo "$1 reference absolute $BUNDLE_DIR dir"
    ok="false"
  fi

  if [[ "$ok" == "false" ]]; then
      error "error encountered for grep of $1"
  fi
}

function check_other_files_links() {
  cd ${BUNDLE_DIR}
  ok="true"
  # -I --> ignore binary files
  EXCLUDE="-I --exclude *.html --exclude *.html --exclude *.html"
  # all other files
  echo "###########################################"
  echo " grep /usr/local/"
  echo "###########################################"
  if grep -rni /usr/local/ . $EXCLUDE
  then
    grep -rni /usr/local/ . $EXCLUDE
    echo "Some scripts reference absolute /usr/local/ dir"
    # treat these as a warnings only, do not error when something refers to it
  fi

  echo "###########################################"
  echo " grep $QGIS_INSTALL_DIR"
  echo "###########################################"
  if grep -rni $QGIS_INSTALL_DIR . $EXCLUDE
  then
    grep -rni $QGIS_INSTALL_DIR . $EXCLUDE
    echo "Some scripts reference absolute $QGIS_INSTALL_DIR dir"
    ok="false"
  fi

  echo "###########################################"
  echo " grep $ROOT_OUT_PATH"
  echo "###########################################"
  if grep -rni $ROOT_OUT_PATH . $EXCLUDE
  then
    grep -rni $ROOT_OUT_PATH . $EXCLUDE
    echo "Some scripts reference absolute $ROOT_OUT_PATH dir"
    ok="false"
  fi

  echo "###########################################"
  echo " grep $BUNDLE_DIR"
  echo "###########################################"
  if grep -rni $BUNDLE_DIR . $EXCLUDE
  then
    grep -rni $BUNDLE_DIR . $EXCLUDE
    echo "Some scripts reference absolute $BUNDLE_DIR dir"
    ok="false"
  fi

  if [[ "$ok" == "false" ]]; then
      error "error encountered for grep of all files"
  fi
}

function verify_binary() {
  BINARY=$1

  if [ ! -f "$BINARY" ]; then
    error "Missing binary: ${BINARY}... Maybe you updated the library version in the receipt?"
  fi

  BIN=$(realpath --relative-to=$BUNDLE_DIR $BINARY)
  check_binary_linker_links $BIN
}

function verify_file_paths() {
  FNAME=$1

  if [ ! -f "$FNAME" ]; then
    error "Missing file: ${FNAME}"
  fi

  check_file_path $FNAME
}

run_final_check() {
  info "Running final check in the ${BUNDLE_DIR}"

  # libs
  info "Check libraries"
  cd "${BUNDLE_DIR}"
  LIBS1=`find . -type f -name "*.so"`
  LIBS2=`find . -type f -name "*.dylib"`
  LIBS="$LIBS1 $LIBS2"
  for lib in $LIBS; do
    echo "checking $lib"
    check_binary_linker_links $lib
  done

  info "Check binaries"
  # frameworks (Mach-O without binaries)
  LIBS=`find . -type f ! -name "*.*"`
  BIN1=`find $BUNDLE_MACOS_DIR/grass${VERSION_grass_major}${VERSION_grass_minor} -type f`
  for lib in $LIBS $BIN1; do
    attachmenttype=$(file $lib | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      echo "checking $lib"
      check_binary_linker_links $lib
    fi
  done

  info "Check other files"
  check_other_files_links
}

run_clean_tmp_files() {
  info "Clean tmp files"

  cd "${BUNDLE_DIR}"

  # files
  for i in *.swp *.orig *.a *.pyc *.c *.cpp *.h *.hpp *.cmake *.prl
  do
    info "Cleaning $i files"
    find . -type fl -name $i -exec rm -f {} +
  done

  # dirs
  for i in include Headers __pycache__ man
  do
    info "Cleaning $i dirs"
    find . -type dl -name "$i" -exec rm -rf {} +
  done
}

function run() {
  export -f install_name_change
  export -f error
  export -f try

  run_prepare_bundle_dir
  run_source_modules
  run_check
  run_bundle
  run_postbundle
  run_clean_tmp_files
  run_final_check
  info "All done !"
}

run
